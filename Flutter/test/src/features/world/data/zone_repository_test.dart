import 'package:flutter_test/flutter_test.dart';
import 'package:pokeclickerlive/src/features/world/data/zone_repository.dart';

void main() {
  group('ZoneRepository Boss Data', () {
    late ZoneRepository repository;

    setUp(() {
      repository = ZoneRepository();
    });

    test('Route 201 should have a boss Pokemon defined', () {
      final route201 = repository.getZoneById('route-201');

      expect(route201, isNotNull);
      expect(route201!.bossPokemonId, isNotNull);
      expect(route201.bossPokemonId, equals(402)); // Kricketune
    });

    test('Route 201 boss should have a timer duration', () {
      final route201 = repository.getZoneById('route-201');

      expect(route201, isNotNull);
      expect(route201!.bossTimerSeconds, isNotNull);
      expect(route201.bossTimerSeconds, equals(30));
    });

    test('Route 202 should have a boss Pokemon defined', () {
      final route202 = repository.getZoneById('route-202');

      expect(route202, isNotNull);
      expect(route202!.bossPokemonId, isNotNull);
    });

    test('Route 202 boss should have a timer duration', () {
      final route202 = repository.getZoneById('route-202');

      expect(route202, isNotNull);
      expect(route202!.bossTimerSeconds, isNotNull);
      expect(route202.bossTimerSeconds, greaterThan(0));
    });

    test('Sandgem Town should not have a boss (towns are safe)', () {
      final sandgemTown = repository.getZoneById('sandgem-town');

      expect(sandgemTown, isNotNull);
      expect(sandgemTown!.bossPokemonId, isNull);
    });
  });
}
