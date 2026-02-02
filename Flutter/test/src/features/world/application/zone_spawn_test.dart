import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeclickerlive/src/features/world/application/zone_controller.dart';

void main() {
  group('Zone-based Pokémon Spawning', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Route 201 spawns only return IDs from its pool', () {
      // Route 201 has pokemonIds: [396, 399, 401, 403]
      final controller = container.read(zoneControllerProvider.notifier);

      // Generate 100 spawns to test distribution
      final spawnedIds = <int>{};
      for (var i = 0; i < 100; i++) {
        final id = controller.getRandomPokemonIdFromCurrentZone();
        if (id != null) {
          spawnedIds.add(id);
        }
      }

      // All spawned IDs should be in Route 201's pool
      expect(spawnedIds.every((id) => [396, 399, 401, 403].contains(id)), true);

      // Should have variety (not just one Pokémon)
      expect(spawnedIds.length, greaterThan(1));
    });

    test('Town zones return null (no wild Pokémon)', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Unlock Sandgem Town by recording kills on Route 201
      for (var i = 0; i < 10; i++) {
        controller.recordKill();
      }

      // Switch to town
      final success = controller.selectZone('sandgem-town');
      expect(success, true, reason: 'Should be able to select unlocked town');

      // Town should return null for Pokémon spawns
      final id = controller.getRandomPokemonIdFromCurrentZone();
      expect(id, null);
    });

    test('Spawn randomness produces varied results', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Generate 50 spawns
      final spawns = <int>[];
      for (var i = 0; i < 50; i++) {
        final id = controller.getRandomPokemonIdFromCurrentZone();
        if (id != null) {
          spawns.add(id);
        }
      }

      // Count occurrences of each Pokémon
      final counts = <int, int>{};
      for (var id in spawns) {
        counts[id] = (counts[id] ?? 0) + 1;
      }

      // Should have at least 2 different Pokémon
      expect(counts.keys.length, greaterThanOrEqualTo(2));

      // No single Pokémon should dominate (> 80% of spawns)
      final maxCount = counts.values.reduce((a, b) => a > b ? a : b);
      expect(maxCount / spawns.length, lessThan(0.8));
    });

    test('Zone change triggers new spawn pool', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Start on Route 201
      final route201Ids = <int>{};
      for (var i = 0; i < 20; i++) {
        final id = controller.getRandomPokemonIdFromCurrentZone();
        if (id != null) route201Ids.add(id);
      }

      // Route 201 should NOT have Wurmple (265)
      expect(route201Ids.contains(265), false);

      // Unlock Route 202 by getting kills on Route 201, then Sandgem Town
      for (var i = 0; i < 10; i++) {
        controller.recordKill();
      }
      controller.selectZone('sandgem-town');

      for (var i = 0; i < 10; i++) {
        controller.recordKill();
      }

      // Now switch to Route 202
      final success = controller.selectZone('route-202');
      expect(success, true, reason: 'Route 202 should be unlocked');

      // Get spawns from Route 202
      final route202Ids = <int>{};
      for (var i = 0; i < 100; i++) {
        final id = controller.getRandomPokemonIdFromCurrentZone();
        if (id != null) route202Ids.add(id);
      }

      // Route 202 should have Wurmple (265)
      expect(route202Ids.contains(265), true);
    });
  });
}
