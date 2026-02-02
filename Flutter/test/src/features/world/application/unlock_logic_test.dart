import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeclickerlive/src/features/world/application/zone_controller.dart';

void main() {
  group('Unlock Logic Fix', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'Route 202 unlocks after 10 kills on Route 201 (Fixing the dependency)',
      () {
        final controller = container.read(zoneControllerProvider.notifier);

        // Initially Route 202 is locked
        final initialState = container.read(zoneControllerProvider);
        final route202Initial = initialState.allZones.firstWhere(
          (z) => z.id == 'route-202',
        );
        expect(route202Initial.isUnlocked, isFalse);

        // Record 10 kills on Route 201
        for (var i = 0; i < 10; i++) {
          controller.recordKill();
        }

        // Verify Route 202 is now unlocked (This should FAIL before the fix)
        final updatedState = container.read(zoneControllerProvider);
        final route202Updated = updatedState.allZones.firstWhere(
          (z) => z.id == 'route-202',
        );
        expect(
          route202Updated.isUnlocked,
          isTrue,
          reason: 'Route 202 should unlock after Route 201 kills',
        );
      },
    );

    test('recordKill 10 times sets newlyUnlockedZoneName for notification', () {
      final controller = container.read(zoneControllerProvider.notifier);

      // Record 9 kills (no unlock yet)
      for (var i = 0; i < 9; i++) {
        controller.recordKill();
        expect(
          container.read(zoneControllerProvider).newlyUnlockedZoneNames,
          isEmpty,
        );
      }

      // Record 10th kill (unlocks Sandgem Town AND Route 202)
      controller.recordKill();

      final state = container.read(zoneControllerProvider);
      // It should contain newly unlocked zones
      expect(state.newlyUnlockedZoneNames, isNotEmpty);
      expect(state.newlyUnlockedZoneNames, contains('Sandgem Town'));
      expect(state.newlyUnlockedZoneNames, contains('Route 202'));
    });
  });
}
