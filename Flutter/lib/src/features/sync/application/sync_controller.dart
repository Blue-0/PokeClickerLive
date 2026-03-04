import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/data/auth_repository.dart';
import '../../clicker/application/clicker_controller.dart';
import '../../collection/application/collection_controller.dart';
import '../../collection/application/team_controller.dart';
import '../../shop/application/inventory_controller.dart';
import '../../shop/application/shop_controller.dart';
import '../../world/application/zone_controller.dart';
import '../../prestige/application/prestige_controller.dart';
import '../data/cloud_save_repository.dart';
import '../domain/sync_state.dart';

part 'sync_controller.g.dart';

@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  Timer? _syncTimer;

  @override
  SyncState build() {
    ref.onDispose(() => _syncTimer?.cancel());

    // Listen to auth changes to start/stop timer
    ref.listen(authRepositoryProvider, (previous, next) {
      _updateTimerBasedOnAuth();
    });

    // Initial timer setup based on current auth state
    _updateTimerBasedOnAuth();

    // Auto-restore from cloud if already authenticated (e.g. app restart
    // with a cached session). Scheduled as a microtask so build() returns
    // synchronously and game controllers can initialize first.
    final authRepo = ref.read(authRepositoryProvider);
    if (authRepo.getToken() != null) {
      Future.microtask(() => loadAndRestore());
    }

    return const SyncState();
  }

  void _updateTimerBasedOnAuth() {
    final authRepo = ref.read(authRepositoryProvider);
    if (authRepo.getToken() != null) {
      _startSyncTimer();
    } else {
      _syncTimer?.cancel();
      _syncTimer = null;
    }
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      sync();
    });
  }

  Future<void> sync() async {
    final authRepo = ref.read(authRepositoryProvider);
    if (authRepo.getToken() == null) return;

    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true, lastError: null);

    final localData = _aggregateData();
    final result = await ref
        .read(cloudSaveRepositoryProvider)
        .syncData(lastSync: state.lastSyncTimestamp, localData: localData);

    result.fold(
      (failure) {
        // Increment consecutive failure counter for M4
        final newFailCount = state.consecutiveFailures + 1;
        state = state.copyWith(
          isSyncing: false,
          lastError: failure,
          hasPendingSync: true,
          consecutiveFailures: newFailCount,
        );
      },
      (data) {
        final serverTimestamp = data['server_timestamp'] as int? ?? 0;
        final cloudData = data['cloud_data'] as Map<String, dynamic>?;

        state = state.copyWith(
          isSyncing: false,
          lastSyncTimestamp: serverTimestamp,
          hasPendingSync: false,
          consecutiveFailures: 0, // Reset on success
          cloudDataReceived: cloudData, // Store for UI to handle (AC-5/L3)
        );
      },
    );
  }

  /// Clears the received cloud data after user has made a decision
  void clearCloudData() {
    state = state.copyWith(cloudDataReceived: null);
  }

  /// Invalidates all keepAlive game controllers so they rebuild from their
  /// default (empty) state. Called on logout and when switching accounts so
  /// the previous user's in-memory data is never shown to the next user.
  void resetGameControllers() {
    // Cancel the periodic sync timer so stale data is never pushed while
    // controllers are in their default/empty state.
    _syncTimer?.cancel();
    _syncTimer = null;

    ref.invalidate(clickerControllerProvider);
    ref.invalidate(prestigeControllerProvider);
    ref.invalidate(shopControllerProvider);
    ref.invalidate(inventoryControllerProvider);
    ref.invalidate(zoneControllerProvider);
    ref.invalidate(collectionControllerProvider);
    // Reset sync state (timestamps, errors, pending flags)
    state = const SyncState();
  }

  /// Fetches cloud save data from the server and restores all game controllers.
  /// Called once after login so the player gets their progress back immediately.
  /// After a successful restore, an immediate sync is scheduled so the current
  /// state is saved to the server without waiting for the 60-second timer.
  Future<void> loadAndRestore() async {
    final authRepo = ref.read(authRepositoryProvider);
    if (authRepo.getToken() == null) return;

    // Guard against concurrent calls (e.g. auto-restore + explicit login)
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true, lastError: null);

    final result = await ref.read(cloudSaveRepositoryProvider).loadData();

    result.fold(
      (failure) {
        state = state.copyWith(isSyncing: false, lastError: failure);
      },
      (cloudData) {
        _restoreFromCloudData(cloudData);
        state = state.copyWith(isSyncing: false, consecutiveFailures: 0);
        // Ensure the periodic sync timer is running after a successful restore
        _startSyncTimer();
        // Push current state to the server immediately so progress is saved
        // without having to wait for the first 60-second timer tick.
        Future.microtask(() => sync());
      },
    );
  }

  /// Applies cloud save data to all game controllers.
  /// Restoration order: prestige → clicker → shop → world → collection.
  /// Falls back to user-level stats when game_state is unavailable.
  void _restoreFromCloudData(Map<String, dynamic> cloudData) {
    final gameState = cloudData['game_state'];
    final Map<String, dynamic>? gs =
        gameState is Map ? Map<String, dynamic>.from(gameState) : null;

    if (gs != null) {
      // 1. Prestige first (its bonus affects other calculations)
      final prestigeData = gs['prestige'];
      if (prestigeData is Map) {
        ref
            .read(prestigeControllerProvider.notifier)
            .restoreFromCloud(Map<String, dynamic>.from(prestigeData));
      }

      // 2. Clicker (currency, level, clickPower, dps, critChance)
      final clickerData = gs['clicker'];
      if (clickerData is Map) {
        ref
            .read(clickerControllerProvider.notifier)
            .restoreFromCloud(Map<String, dynamic>.from(clickerData));
      }

      // 3. Shop upgrade levels (display only; clicker stats already restored above)
      final shopData = gs['shop'];
      if (shopData is Map) {
        ref
            .read(shopControllerProvider.notifier)
            .restoreFromCloud(Map<String, dynamic>.from(shopData));
      }

      // 4. Zone kill counts and current zone
      final worldData = gs['world'];
      if (worldData is Map) {
        ref
            .read(zoneControllerProvider.notifier)
            .restoreFromCloud(Map<String, dynamic>.from(worldData));
      }
    } else {
      // Fallback: restore currency from the user-level pokedollars column
      // when game_state has not been persisted yet.
      final userData = cloudData['user'];
      if (userData is Map) {
        final pokedollars = (userData['pokedollars'] as num?)?.toInt();
        if (pokedollars != null && pokedollars > 0) {
          ref
              .read(clickerControllerProvider.notifier)
              .restoreFromCloud({'currency': pokedollars});
        }
      }
    }

    // 5. Pokemon collection (from server DB rows – independent of game_state)
    final pokemonList = cloudData['pokemon'];
    if (pokemonList is List && pokemonList.isNotEmpty) {
      ref
          .read(collectionControllerProvider.notifier)
          .restoreFromCloud(pokemonList);
    }
  }

  Map<String, dynamic> _aggregateData() {
    final clickerState = ref.read(clickerControllerProvider);
    final inventoryState = ref.read(inventoryControllerProvider);
    final zoneState = ref.read(zoneControllerProvider);
    final collectionState = ref.read(collectionControllerProvider);
    final teamState = ref.read(teamControllerProvider);
    final shopState = ref.read(shopControllerProvider);

    return {
      'clicker': {
        'currency': clickerState.currency,
        'level': clickerState.level,
        'clickPower': clickerState.clickPower,
        'dps': clickerState.dps,
        'critChance': clickerState.critChance,
      },
      'inventory': inventoryState.items,
      'world': {
        'killCounts': zoneState.killCounts,
        'currentZoneId': zoneState.currentZone.id,
      },
      'collection': collectionState.ownedPokemon
          .map((p) => p.toJson())
          .toList(),
      'team': teamState.activePokemonIds,
      'shop': {for (final u in shopState.upgrades) u.id: u.level},
      'prestige': {
        'level': ref.read(prestigeControllerProvider).prestigeLevel,
        'badges': ref.read(prestigeControllerProvider).badgesAmount,
      },
    };
  }
}
