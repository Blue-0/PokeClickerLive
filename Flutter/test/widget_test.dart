import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MaterialApp can be created', (WidgetTester tester) async {
    // Simple smoke test - just verify Flutter test framework works
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('PokeClicker'))),
      ),
    );

    expect(find.text('PokeClicker'), findsOneWidget);
  });
}
