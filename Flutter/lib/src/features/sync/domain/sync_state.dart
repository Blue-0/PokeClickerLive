import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_state.freezed.dart';

@freezed
abstract class SyncState with _$SyncState {
  const factory SyncState({
    @Default(false) bool isSyncing,
    @Default(0) int lastSyncTimestamp,
    String? lastError,
    @Default(false) bool hasPendingSync,
    @Default(0) int consecutiveFailures, // M4: Track repeated failures
    Map<String, dynamic>?
    cloudDataReceived, // L3: Store cloud data for UI prompt
  }) = _SyncState;

  const SyncState._();
}
