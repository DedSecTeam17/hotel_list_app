import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_list_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('should load hotels and display them in grid after splash screen',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));

    final hotelItems = find.byWidgetPredicate((widget) {
      return widget.key != null &&
          widget.key is Key &&
          widget.key.toString().contains('hotel_item_');
    });

    expect(hotelItems, findsWidgets);

    await tester.drag(find.byType(GridView), const Offset(0, -300));
    await tester.pump();

    expect(hotelItems, findsWidgets);
  });
}
