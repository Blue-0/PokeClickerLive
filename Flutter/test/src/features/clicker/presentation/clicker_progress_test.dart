import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeclickerlive/src/features/clicker/presentation/clicker_screen.dart';
import 'package:pokeclickerlive/src/features/world/application/zone_controller.dart';

void main() {
  group('Clicker Screen Progress', () {
    testWidgets('shows kill progress when target available', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ClickerScreen())),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Initially should show Route 201 progress (0/10)
      expect(find.text('Kills: 0 / 10'), findsOneWidget);

      // Record a kill via controller
      final container = ProviderScope.containerOf(
        tester.element(find.byType(ClickerScreen)),
      );
      container.read(zoneControllerProvider.notifier).recordKill();

      await tester.pump();

      // Should show updated progress
      expect(find.text('Kills: 1 / 10'), findsOneWidget);
    });

    testWidgets('shows snackbar when zone is unlocked', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ClickerScreen())),
      );

      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ClickerScreen)),
      );
      final controller = container.read(zoneControllerProvider.notifier);

      // Record 10 kills
      for (var i = 0; i < 10; i++) {
        controller.recordKill();
      }

      // SnackBar might take a frame to appear
      await tester.pump();

      // Should find SnackBar with unlock message
      // Note: In tests, we look for the text within the SnackBar
      expect(find.textContaining('New Zone Unlocked'), findsWidgets);
      expect(find.textContaining('Sandgem Town'), findsWidgets);
    });
  });
}
