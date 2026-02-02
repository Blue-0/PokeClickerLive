import 'dart:async';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pokeclickerlive/src/features/pokemon/application/pokemon_provider.dart';
import 'package:pokeclickerlive/src/features/world/application/zone_controller.dart';
import '../domain/clicker_state.dart';

part 'clicker_controller.g.dart';

@riverpod
class ClickerController extends _$ClickerController {
  Timer? _autoClickTimer;

  @override
  ClickerState build() {
    // Cleanup timer on dispose
    ref.onDispose(() {
      _autoClickTimer?.cancel();
    });

    // Schedule loading after build completes to avoid blocking
    Future.microtask(() => _loadNewPokemon());
    return const ClickerState(isLoading: true);
  }

  Future<void> _loadNewPokemon() async {
    state = state.copyWith(isLoading: true);

    final repo = ref.read(pokemonRepositoryProvider);

    // Get Pokémon ID from current zone (AC-6 integration)
    final zoneController = ref.read(zoneControllerProvider.notifier);
    final zonePokemonId = zoneController.getRandomPokemonIdFromCurrentZone();

    // If zone has specific Pokémon, use those; otherwise fall back to random Sinnoh
    final result = zonePokemonId != null
        ? await repo.getPokemon(zonePokemonId)
        : await repo.getRandomSinnohPokemon();

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
        state = state.copyWith(
          isLoading: false,
          currentHp: pokemon.hp,
          maxHp: pokemon.hp,
          currentPokemon: pokemon,
        );
      },
    );
  }

  void click() {
    if (state.isLoading) return;

    // Calculate damage with click power and critical hit
    int damage = state.clickPower;
    final random = Random();
    if (random.nextInt(100) < state.critChance) {
      damage *= 2; // Critical hit!
    }

    state = state.copyWith(currentHp: state.currentHp - damage);

    if (state.currentHp <= 0) {
      _defeatEnemy();
    }
  }

  void _defeatEnemy() {
    final pokemon = state.currentPokemon;
    final reward = pokemon != null ? (pokemon.attack ~/ 10) + 5 : 5;

    state = state.copyWith(
      currency: state.currency + reward,
      level: state.level + 1,
    );

    _loadNewPokemon();
  }

  /// Called by auto-clicker (DPS)
  void _autoTick() {
    if (state.isLoading || state.dps <= 0) return;

    state = state.copyWith(currentHp: state.currentHp - state.dps);

    if (state.currentHp <= 0) {
      _defeatEnemy();
    }
  }

  void _startAutoClicker() {
    _autoClickTimer?.cancel();
    if (state.dps > 0) {
      _autoClickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _autoTick();
      });
    }
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
}
