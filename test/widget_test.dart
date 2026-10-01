// BrewBuddy — smoke test
// Verifies that the app widget tree builds without throwing.

import 'package:flutter_test/flutter_test.dart';

import 'package:brew_buddy/main.dart';

void main() {
  testWidgets('App smoke test — builds without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BrewBuddyApp());
    // If the widget tree builds we are good.
    expect(find.byType(BrewBuddyApp), findsOneWidget);
  });
}
