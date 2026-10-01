// BrewBuddy — smoke test
// Verifies that the app widget tree builds without throwing.

import 'package:flutter_test/flutter_test.dart';

import 'package:brew_buddy/main.dart';

void main() {
  testWidgets('App smoke test — builds without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BrewBuddyApp());
    // Pump one frame so the widget tree is built
    await tester.pump();
    // If the widget tree builds we are good.
    expect(find.byType(BrewBuddyApp), findsOneWidget);
    // Cancel any pending timers (e.g. SplashScreen 2s delay) without navigating
    await tester.pump(const Duration(seconds: 3));
  });
}
