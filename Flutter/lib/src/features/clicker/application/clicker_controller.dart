import 'dart:async';
import 'package:pokeclickerlive/src/features/collection/application/team_dps_provider.dart';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pokeclickerlive/src/features/pokemon/application/pokemon_provider.dart';
import 'package:pokeclickerlive/src/features/world/application/zone_controller.dart';
import 'package:pokeclickerlive/src/features/world/domain/zone_type.dart';
import '../../collection/application/collection_controller.dart';
import '../../collection/application/capture_service.dart';
import '../domain/clicker_state.dart';
import '../../prestige/application/prestige_controller.dart';

part 'clicker_controller.g.dart';

@Riverpod(keepAlive: true)
class ClickerController extends _$ClickerController {
  Timer? _autoClickTimer;
  Timer? _bossTimer;

  @override
  ClickerState build() {
    // Cleanup timers on dispose
    ref.onDispose(() {
      _autoClickTimer?.cancel();
      _bossTimer?.cancel();
    });

    // Listen to team DPS changes
    ref.listen(teamDpsProvider, (previous, next) {
      if (next is AsyncData<int>) {
        state = state.copyWith(teamDps: next.value);
        _startAutoClicker();
      }
    });

    // Listen to zone changes to reset combat
    ref.listen(zoneControllerProvider, (previous, next) {
      if (previous?.currentZone.id != next.currentZone.id) {
        _loadNewPokemon();
      }
    });

    // Schedule loading after build completes to avoid blocking
    Future.microtask(() {
      if (!ref.mounted) return;
      _loadNewPokemon();
    });
    return const ClickerState(isLoading: true);
  }

  Future<void> _loadNewPokemon({bool forceBoss = false}) async {
    if (!ref.mounted) return;
    state = state.copyWith(
      isLoading: true,
      isBoss: false,
      remainingBossTime: 0,
    );
    _bossTimer?.cancel();

    final repo = ref.read(pokemonRepositoryProvider);

    // Get Pokémon ID from current zone (AC-6 integration)
    final zoneController = ref.read(zoneControllerProvider.notifier);
    final zoneState = ref.read(zoneControllerProvider);
    final currentZone = zoneState.currentZone;
    final kills = zoneState.killCounts[currentZone.id] ?? 0;
    final target = zoneController.getKillTargetForCurrentZone() ?? 10;

    int? pokemonId;
    bool spawningBoss = false;

    // Handle dedicated Boss Zones OR legacy auto-spawn exactly at target
    if (currentZone.type == ZoneType.boss) {
      pokemonId = currentZone.bossPokemonId;
      spawningBoss = true;
    } else if (forceBoss || (zoneController.isBossReady() && kills == target)) {
      pokemonId = zoneController.getBossPokemonId();
      spawningBoss = true;
    } else {
      pokemonId = zoneController.getRandomPokemonIdFromCurrentZone();
    }

    // If zone has no Pokémon (Towns), stop here
    if (pokemonId == null) {
      state = state.copyWith(isLoading: false, currentPokemon: null);
      return;
    }

    // If zone has specific Pokémon, use those; otherwise fall back to random Sinnoh
    final result = await repo.getPokemon(pokemonId);
    if (!ref.mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          currentHp: 50,
          maxHp: 50,
          currentPokemon: null,
        );
      },
      (pokemon) {
        int maxHp = pokemon.hp;
        int remainingTime = 0;

        if (spawningBoss) {
          maxHp *= 5; // AC-2: Boss HP Scaling
          remainingTime =
              ref.read(zoneControllerProvider).currentZone.bossTimerSeconds ??
              30;
          _startBossTimer(); // AC-3: Countdown timer starts
        }

        state = state.copyWith(
          isLoading: false,
          currentHp: maxHp,
          maxHp: maxHp,
          currentPokemon: pokemon,
          isBoss: spawningBoss,
          remainingBossTime: remainingTime,
        );
      },
    );
  }

  void click() {
    if (state.isLoading || state.currentPokemon == null) return;

    final prestigeMultiplier = ref
        .read(prestigeControllerProvider)
        .permanentBonus;
    final damage = (state.clickPower * prestigeMultiplier).floor();
    final isCrit = Random().nextInt(100) < state.critChance;
    final totalDamage = isCrit ? damage * 2 : damage;

    final newHp = max(0, state.currentHp - totalDamage);
    state = state.copyWith(currentHp: newHp);

    if (newHp <= 0) {
      _defeatEnemy();
    }
  }

  /// Manually start the boss encounter for the current zone
  Future<void> startBossEncounter() async {
    final zoneController = ref.read(zoneControllerProvider.notifier);
    final zoneState = ref.read(zoneControllerProvider);

    // If we have an unlocked boss zone for current zone, move to it
    final bossZone = zoneState.allZones.where((z) {
      return z.type == ZoneType.boss &&
          z.unlockCondition?.sourceZoneId == zoneState.currentZone.id &&
          z.isUnlocked;
    }).firstOrNull;

    if (bossZone != null) {
      zoneController.changeZone(bossZone);
    } else {
      // Fallback for legacy auto-trigger (if boss is in the same zone)
      if (!zoneController.isBossReady()) return;
      await _loadNewPokemon(forceBoss: true);
    }
  }

  void _defeatEnemy() {
    final pokemon = state.currentPokemon;
    int reward = pokemon != null ? (pokemon.attack ~/ 10) + 5 : 5;

    final prestigeMultiplier = ref
        .read(prestigeControllerProvider)
        .permanentBonus;
    reward = (reward * prestigeMultiplier).floor();

    if (state.isBoss) {
      reward *= 5; // AC-6: Defeating a boss provides larger reward
    }

    // Record kill for zone progression
    ref.read(zoneControllerProvider.notifier).recordKill();

    // Trigger capture attempt
    if (pokemon != null) {
      final captureService = ref.read(captureServiceProvider.notifier);
      final result = captureService.attemptCapture(pokemon.id);

      ref
          .read(collectionControllerProvider.notifier)
          .recordCaptureAttempt(pokemon.id, result);
    }

    state = state.copyWith(
      currency: state.currency + reward,
      level: state.level + 1,
    );

    _loadNewPokemon();
  }

  void _startBossTimer() {
    _bossTimer?.cancel();
    _bossTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!ref.mounted) {
        timer.cancel();
        return;
      }
      if (state.remainingBossTime <= 0) {
        timer.cancel();
        _onBossTimeout();
      } else {
        state = state.copyWith(remainingBossTime: state.remainingBossTime - 1);
      }
    });
  }

  void _onBossTimeout() {
    // New logic: If in a boss zone, return to the previous zone
    if (ref.read(zoneControllerProvider).currentZone.type == ZoneType.boss) {
      ref.read(zoneControllerProvider.notifier).returnToPreviousZone();
    } else {
      // Legacy fallback
      ref.read(zoneControllerProvider.notifier).decreaseKillCount();
    }
    _loadNewPokemon();
  }

  /// Called by auto-clicker (DPS)
  void _autoTick() {
    if (!ref.mounted) return;
    final zoneState = ref.read(zoneControllerProvider);
    // Peace zones (towns) should not have auto-combat
    if (zoneState.currentZone.type == ZoneType.town) return;

    final prestigeMultiplier = ref
        .read(prestigeControllerProvider)
        .permanentBonus;
    final totalDps = ((state.dps + state.teamDps) * prestigeMultiplier).floor();

    if (state.isLoading || totalDps <= 0 || state.currentPokemon == null) {
      return;
    }

    state = state.copyWith(currentHp: state.currentHp - totalDps);

    if (state.currentHp <= 0) {
      _defeatEnemy();
    }
  }

  void _startAutoClicker() {
    _autoClickTimer?.cancel();
    final totalDps = state.dps + state.teamDps;
    if (totalDps > 0) {
      _autoClickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _autoTick();
      });
    }
  }

  // --- Cloud restore ---

  /// Restores clicker state from a cloud save snapshot.
  /// Called once after login to re-apply server-side progress.
  void restoreFromCloud(Map<String, dynamic> data) {
    state = state.copyWith(
      currency: (data['currency'] as num?)?.toInt() ?? state.currency,
      level: (data['level'] as num?)?.toInt() ?? state.level,
      clickPower: (data['clickPower'] as num?)?.toInt() ?? state.clickPower,
      dps: (data['dps'] as num?)?.toInt() ?? state.dps,
      critChance: (data['critChance'] as num?)?.toInt() ?? state.critChance,
    );
    // Restart auto-clicker with restored DPS
    _startAutoClicker();
  }

  // --- Shop integration methods ---

  void spendCurrency(int amount) {
    state = state.copyWith(currency: state.currency - amount);
  }

  void increaseClickPower(int amount) {
    state = state.copyWith(clickPower: state.clickPower + amount);
  }

  void increaseDps(int amount) {
    state = state.copyWith(dps: state.dps + amount);
    _startAutoClicker();
  }

  void increaseCritChance(int amount) {
    state = state.copyWith(critChance: state.critChance + amount);
  }

  void resetForPrestige() {
    _autoClickTimer?.cancel();
    _bossTimer?.cancel();

    state = const ClickerState(
      currency: 0,
      currentHp: 10,
      maxHp: 10,
      level: 1,
      isLoading: true,
      clickPower: 1,
      dps: 0,
      teamDps: 0,
      critChance: 0,
      isBoss: false,
      remainingBossTime: 0,
    );

    _loadNewPokemon();
  }
}
