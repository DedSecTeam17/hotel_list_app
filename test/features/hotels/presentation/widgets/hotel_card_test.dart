import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/hotel.dart';
import 'package:hotel_list_app/features/hotels/presentation/widgets/hotel_card.dart';

void main() {
  group('HotelCard Widget Tests', () {
    testWidgets('should display hotel title, subtitle and image',
        (tester) async {
      final mockHotel = Hotel(
        name: 'Mock Hotel Name',
        city: 'Mock City',
        location: 'Mock Street',
        type: 'hotel',
        imageUrls: ['https://placekitten.com/400/300'],
        categories: [],
        overviewText: 'Mock Overview',
        thingsToDo: [],
        openingHours: null,
        coordinates: null,
      );

      // Act: Render the HotelCard
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HotelCard(hotel: mockHotel, index: 0),
          ),
        ),
      );

      final titleFinder = find.text('Mock Hotel Name');
      expect(titleFinder, findsOneWidget);

      final subtitleFinder = find.text('Mock City');
      expect(subtitleFinder, findsOneWidget);

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
    });
  });
}
