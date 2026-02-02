import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokeclickerlive/src/features/world/domain/zone.dart';
import 'package:pokeclickerlive/src/features/world/domain/zone_type.dart';
import 'package:pokeclickerlive/src/features/world/domain/unlock_condition.dart';
import 'package:pokeclickerlive/src/features/world/presentation/widgets/zone_tile.dart';

void main() {
  group('ZoneTile', () {
    testWidgets('displays zone name', (WidgetTester tester) async {
      const zone = Zone(
        id: 'route-201',
        name: 'Route 201',
        type: ZoneType.route,
        isUnlocked: true,
        pokemonIds: [1, 2, 3],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ZoneTile(zone: zone, isActive: false, isUnlocked: true),
          ),
        ),
      );

      expect(find.text('Route 201'), findsOneWidget);
    });

    testWidgets('shows CURRENT badge when active', (WidgetTester tester) async {
      const zone = Zone(
        id: 'route-201',
        name: 'Route 201',
        type: ZoneType.route,
        isUnlocked: true,
        pokemonIds: [1, 2, 3],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ZoneTile(zone: zone, isActive: true, isUnlocked: true),
          ),
        ),
      );

      expect(find.text('CURRENT'), findsOneWidget);
    });

    testWidgets('shows species count when unlocked and not active', (
      WidgetTester tester,
    ) async {
      const zone = Zone(
        id: 'route-201',
        name: 'Route 201',
        type: ZoneType.route,
        isUnlocked: true,
        pokemonIds: [1, 2, 3, 4],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ZoneTile(zone: zone, isActive: false, isUnlocked: true),
          ),
        ),
      );

      expect(find.text('4 species'), findsOneWidget);
    });

    testWidgets('shows lock icon when locked', (WidgetTester tester) async {
      const zone = Zone(
        id: 'route-202',
        name: 'Route 202',
        type: ZoneType.route,
        isUnlocked: false,
        pokemonIds: [1, 2, 3],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ZoneTile(zone: zone, isActive: false, isUnlocked: false),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('shows unlock progress when locked with condition', (
      WidgetTester tester,
    ) async {
      final zone = Zone(
        id: 'sandgem-town',
        name: 'Sandgem Town',
        type: ZoneType.town,
        isUnlocked: false,
        unlockCondition: const UnlockCondition(
          killCount: 10,
          sourceZoneId: 'route-201',
        ),
        pokemonIds: const [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZoneTile(
              zone: zone,
              isActive: false,
              isUnlocked: false,
              killProgress: 5,
              killRequired: 10,
            ),
          ),
        ),
      );

      expect(find.text('Defeat 10 Pokémon to unlock'), findsOneWidget);
      expect(find.text('5 / 10'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows town label for town type', (WidgetTester tester) async {
      const zone = Zone(
        id: 'sandgem-town',
        name: 'Sandgem Town',
        type: ZoneType.town,
        isUnlocked: true,
        pokemonIds: [],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ZoneTile(zone: zone, isActive: false, isUnlocked: true),
          ),
        ),
      );

      expect(find.text('Town • Hub Area'), findsOneWidget);
    });

    testWidgets('shows route label for route type', (
      WidgetTester tester,
    ) async {
      const zone = Zone(
        id: 'route-201',
        name: 'Route 201',
        type: ZoneType.route,
        isUnlocked: true,
        pokemonIds: [1],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ZoneTile(zone: zone, isActive: false, isUnlocked: true),
          ),
        ),
      );

      expect(find.text('Route • Wild Pokémon'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped and unlocked', (
      WidgetTester tester,
    ) async {
      bool wasTapped = false;

      const zone = Zone(
        id: 'route-201',
        name: 'Route 201',
        type: ZoneType.route,
        isUnlocked: true,
        pokemonIds: [1],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZoneTile(
              zone: zone,
              isActive: false,
              isUnlocked: true,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ZoneTile));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('does not call onTap when tapped and locked', (
      WidgetTester tester,
    ) async {
      bool wasTapped = false;

      const zone = Zone(
        id: 'route-202',
        name: 'Route 202',
        type: ZoneType.route,
        isUnlocked: false,
        pokemonIds: [1],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ZoneTile(
              zone: zone,
              isActive: false,
              isUnlocked: false,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ZoneTile));
      await tester.pump();

      expect(wasTapped, isFalse);
    });
  });
}
