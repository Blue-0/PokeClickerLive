import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/zone.dart';
import '../domain/zone_type.dart';
import '../domain/unlock_condition.dart';

part 'zone_repository.g.dart';

/// Repository providing zone data.
/// For MVP, zones are hardcoded. In future, could load from JSON/API.
@Riverpod(keepAlive: true)
ZoneRepository zoneRepository(Ref ref) {
  return ZoneRepository();
}

class ZoneRepository {
  /// Get all Sinnoh zones (MVP: Route 201, Sandgem Town, Route 202)
  List<Zone> getAllZones() {
    return _sinnohZones;
  }

  /// Get a zone by its ID
  Zone? getZoneById(String id) {
    return _sinnohZones.where((z) => z.id == id).firstOrNull;
  }

  /// Get the starting zone (always unlocked)
  Zone getStartingZone() {
    return _sinnohZones.first;
  }

  /// Hardcoded Sinnoh zones for MVP
  static final List<Zone> _sinnohZones = [
    // Route 201 - Starting zone, always unlocked
    const Zone(
      id: 'route-201',
      name: 'Route 201',
      type: ZoneType.route,
      isUnlocked: true,
      pokemonIds: [396, 399, 401, 403], // Starly, Bidoof, Kricketot, Shinx
    ),

    // Boss Route 201 - Unlocked after 10 kills on route-201
    const Zone(
      id: 'boss-201',
      name: 'Kricketune (Boss)',
      type: ZoneType.boss,
      isUnlocked: false,
      unlockCondition: UnlockCondition(
        killCount: 10,
        sourceZoneId: 'route-201',
      ),
      bossPokemonId: 402, // Kricketune
      bossTimerSeconds: 30,
    ),

    // Sandgem Town - Hub, unlocked after defeating Boss 201 (1 kill in boss zone)
    const Zone(
      id: 'sandgem-town',
      name: 'Sandgem Town',
      type: ZoneType.town,
      isUnlocked: false,
      unlockCondition: UnlockCondition(killCount: 1, sourceZoneId: 'boss-201'),
      pokemonIds: [],
    ),

    // Route 202 - Next route
    const Zone(
      id: 'route-202',
      name: 'Route 202',
      type: ZoneType.route,
      isUnlocked: false,
      unlockCondition: UnlockCondition(
        killCount: 1,
        sourceZoneId: 'sandgem-town',
      ),
      pokemonIds: [396, 399, 401, 403, 265], // +Wurmple
    ),

    // Boss Route 202
    const Zone(
      id: 'boss-202',
      name: 'Buizel (Boss)',
      type: ZoneType.boss,
      isUnlocked: false,
      unlockCondition: UnlockCondition(
        killCount: 10,
        sourceZoneId: 'route-202',
      ),
      bossPokemonId: 418, // Buizel
      bossTimerSeconds: 30,
    ),
  ];
}
