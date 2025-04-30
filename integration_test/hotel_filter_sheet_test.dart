import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_list_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('should open filter sheet, select first filter and apply it',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));

    final fab = find.byKey(const Key('open_filter_sheet_button'));
    expect(fab, findsOneWidget);

    await tester.tap(fab);
    await tester.pumpAndSettle();

    final firstFilter = find.byKey(const Key('filter_chip_0_0'));
    expect(firstFilter, findsOneWidget);

    await tester.tap(firstFilter);
    await tester.pumpAndSettle();

    final applyButton = find.byKey(const Key('apply_filter_button'));
    expect(applyButton, findsOneWidget);

    await tester.tap(applyButton);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('filter_chip_0_0')), findsNothing);
  });
}
