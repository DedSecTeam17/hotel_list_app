import 'hotel.dart';
import 'filter.dart';

class HotelsData {
  final List<Hotel> hotels;
  final List<FilterGroup> filters;

  HotelsData({
    required this.hotels,
    required this.filters,
  });
}
