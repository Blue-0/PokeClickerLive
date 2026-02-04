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
