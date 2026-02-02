import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    // Sandgem Town - Hub, unlocked after 10 kills on Route 201
    Zone(
      id: 'sandgem-town',
      name: 'Sandgem Town',
      type: ZoneType.town,
      isUnlocked: false,
      unlockCondition: const UnlockCondition(
        killCount: 10,
        sourceZoneId: 'route-201',
      ),
      pokemonIds: const [], // Towns don't have wild Pokémon
    ),

    // Route 202 - Next route
    Zone(
      id: 'route-202',
      name: 'Route 202',
      type: ZoneType.route,
      isUnlocked: false,
      unlockCondition: const UnlockCondition(
        killCount: 10,
        sourceZoneId: 'route-201',
      ),
      pokemonIds: const [396, 399, 401, 403, 265], // +Wurmple
    ),
  ];
}
