import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_list_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('should navigate to HotelDetailPage on hotel item tap',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    final firstHotelItem = find.byKey(const Key('hotel_item_0'));
    expect(firstHotelItem, findsOneWidget);

    await tester.tap(firstHotelItem);
    await tester.pumpAndSettle();

    final hotelDetailPage = find.byKey(const Key('hotel_detail_page'));
    expect(hotelDetailPage, findsOneWidget);

    final hotelTitle = find.byKey(const Key('hotel_title'));
    expect(hotelTitle, findsOneWidget);
  });
}
