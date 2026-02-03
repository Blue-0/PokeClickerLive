import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'zone_persistence_service.g.dart';

/// Service for persisting zone-related data using Hive
class ZonePersistenceService {
  static const String _boxName = 'zone_data';
  static const String _currentZoneKey = 'current_zone_id';
  static const String _killCountsKey = 'kill_counts';

  Box? _box;

  /// Initialize the persistence service
  Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox(_boxName);
  }

  /// Save the current zone ID
  Future<void> saveCurrentZoneId(String zoneId) async {
    await _ensureInitialized();
    await _box!.put(_currentZoneKey, zoneId);
  }

  /// Load the saved current zone ID (returns null if none saved)
  Future<String?> loadCurrentZoneId() async {
    await _ensureInitialized();
    return _box!.get(_currentZoneKey) as String?;
  }

  /// Save kill counts per zone
  Future<void> saveKillCounts(Map<String, int> killCounts) async {
    await _ensureInitialized();
    await _box!.put(_killCountsKey, killCounts);
  }

  /// Load saved kill counts (returns empty map if none saved)
  Future<Map<String, int>> loadKillCounts() async {
    await _ensureInitialized();
    final data = _box!.get(_killCountsKey);
    if (data == null) return {};
    // Hive returns Map<dynamic, dynamic>, need to cast
    return Map<String, int>.from(data as Map);
  }

  Future<void> _ensureInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
  }

  /// Clear all zone data (for testing or reset)
  Future<void> clear() async {
    await _ensureInitialized();
    await _box!.clear();
  }
}

/// Provider for zone persistence service
@Riverpod(keepAlive: true)
ZonePersistenceService zonePersistenceService(Ref ref) {
  return ZonePersistenceService();
}
