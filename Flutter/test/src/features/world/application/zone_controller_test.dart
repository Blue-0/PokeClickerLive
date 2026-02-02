import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeclickerlive/src/features/world/application/zone_controller.dart';
import 'package:pokeclickerlive/src/features/world/data/zone_repository.dart';

void main() {
  group('ZoneController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has Route 201 as current zone', () {
      final state = container.read(zoneControllerProvider);

      expect(state.currentZone.id, equals('route-201'));
      expect(state.currentZone.name, equals('Route 201'));
      expect(state.currentZone.isUnlocked, isTrue);
    });

    test('initial state has 3 zones loaded', () {
      final state = container.read(zoneControllerProvider);

      expect(state.allZones.length, equals(3));
    });

    test('selectZone returns true for unlocked zone', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Route 201 is unlocked by default
      final result = controller.selectZone('route-201');

      expect(result, isTrue);
    });

    test('selectZone returns false for locked zone', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Route 202 is locked initially
      final result = controller.selectZone('route-202');

      expect(result, isFalse);
    });

    test('selectZone returns false for non-existent zone', () {
      final controller = container.read(zoneControllerProvider.notifier);

      final result = controller.selectZone('non-existent-zone');

      expect(result, isFalse);
    });

    test('recordKill increments kill count for current zone', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Initial kill count should be 0
      expect(
        container.read(zoneControllerProvider).killCounts['route-201'],
        isNull,
      );

      // Record a kill
      controller.recordKill();

      expect(
        container.read(zoneControllerProvider).killCounts['route-201'],
        equals(1),
      );
    });

    test('recordKill 10 times unlocks Sandgem Town', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Verify Sandgem Town is locked initially
      final initialState = container.read(zoneControllerProvider);
      final sandgemInitial = initialState.allZones.firstWhere(
        (z) => z.id == 'sandgem-town',
      );
      expect(sandgemInitial.isUnlocked, isFalse);

      // Record 10 kills
      for (var i = 0; i < 10; i++) {
        controller.recordKill();
      }

      // Verify Sandgem Town is now unlocked
      final updatedState = container.read(zoneControllerProvider);
      final sandgemUpdated = updatedState.allZones.firstWhere(
        (z) => z.id == 'sandgem-town',
      );
      expect(sandgemUpdated.isUnlocked, isTrue);
    });

    test('can select zone after it becomes unlocked', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Initially can't select Sandgem Town
      expect(controller.selectZone('sandgem-town'), isFalse);

      // Record 10 kills to unlock it
      for (var i = 0; i < 10; i++) {
        controller.recordKill();
      }

      // Now should be able to select it
      expect(controller.selectZone('sandgem-town'), isTrue);

      // Verify current zone changed
      final state = container.read(zoneControllerProvider);
      expect(state.currentZone.id, equals('sandgem-town'));
    });

    test('getRandomPokemonIdFromCurrentZone returns valid ID', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Route 201 has Pokémon IDs: [396, 399, 401, 403]
      final pokemonId = controller.getRandomPokemonIdFromCurrentZone();

      expect(pokemonId, isNotNull);
      expect([396, 399, 401, 403], contains(pokemonId));
    });

    test('getRandomPokemonIdFromCurrentZone returns null for town', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Unlock and select Sandgem Town
      for (var i = 0; i < 10; i++) {
        controller.recordKill();
      }
      controller.selectZone('sandgem-town');

      // Towns have no wild Pokémon
      final pokemonId = controller.getRandomPokemonIdFromCurrentZone();

      expect(pokemonId, isNull);
    });
  });

  group('ZoneRepository', () {
    test('getAllZones returns 3 zones', () {
      final repository = ZoneRepository();
      final zones = repository.getAllZones();

      expect(zones.length, equals(3));
    });

    test('getStartingZone returns Route 201', () {
      final repository = ZoneRepository();
      final startingZone = repository.getStartingZone();

      expect(startingZone.id, equals('route-201'));
      expect(startingZone.isUnlocked, isTrue);
    });

    test('getZoneById returns correct zone', () {
      final repository = ZoneRepository();

      final zone = repository.getZoneById('sandgem-town');

      expect(zone, isNotNull);
      expect(zone!.name, equals('Sandgem Town'));
    });

    test('getZoneById returns null for non-existent zone', () {
      final repository = ZoneRepository();

      final zone = repository.getZoneById('non-existent');

      expect(zone, isNull);
    });
  });
}
