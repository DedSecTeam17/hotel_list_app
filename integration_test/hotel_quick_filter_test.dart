import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_list_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('should tap each quick filter, select then unselect all',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));

    const int quickFilterCount = 2;

    for (int i = 0; i < quickFilterCount; i++) {
      final filterFinder = find.byKey(Key('quick_filter_$i'));
      expect(filterFinder, findsOneWidget);

      await tester.tap(filterFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(filterFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
    }
  });
}
