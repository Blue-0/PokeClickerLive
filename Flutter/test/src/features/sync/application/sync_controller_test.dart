// SyncController tests are complex due to multiple provider dependencies.
// These tests are deferred pending integration test setup.
// See: test/integration/sync_controller_integration_test.dart (to be created)

import 'package:flutter_test/flutter_test.dart';
import 'package:pokeclickerlive/src/features/sync/domain/sync_state.dart';

void main() {
  group('SyncState', () {
    test('initial state has correct default values', () {
      const state = SyncState();

      expect(state.isSyncing, false);
      expect(state.lastSyncTimestamp, 0);
      expect(state.lastError, null);
      expect(state.hasPendingSync, false);
      expect(state.consecutiveFailures, 0);
      expect(state.cloudDataReceived, null);
    });

    test('copyWith updates only specified fields', () {
      const state = SyncState();
      final updated = state.copyWith(isSyncing: true, lastSyncTimestamp: 12345);

      expect(updated.isSyncing, true);
      expect(updated.lastSyncTimestamp, 12345);
      expect(updated.lastError, null); // unchanged
      expect(updated.hasPendingSync, false); // unchanged
    });

    test('consecutiveFailures increments correctly', () {
      const state = SyncState();

      final failure1 = state.copyWith(consecutiveFailures: 1);
      expect(failure1.consecutiveFailures, 1);

      final failure2 = failure1.copyWith(consecutiveFailures: 2);
      expect(failure2.consecutiveFailures, 2);

      final success = failure2.copyWith(consecutiveFailures: 0);
      expect(success.consecutiveFailures, 0);
    });

    test('cloudDataReceived can store and clear data', () {
      const state = SyncState();
      final cloudData = {
        'clicker': {'currency': 1000},
      };

      final withData = state.copyWith(cloudDataReceived: cloudData);
      expect(withData.cloudDataReceived, cloudData);

      final cleared = withData.copyWith(cloudDataReceived: null);
      expect(cleared.cloudDataReceived, null);
    });
  });
}
