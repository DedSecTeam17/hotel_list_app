import 'hotel_model.dart';
import 'filter_group_model.dart';

class HotelsDataModel {
  final List<FilterGroupModel> filters;
  final List<HotelModel> hotels;

  HotelsDataModel({
    required this.filters,
    required this.hotels,
  });

  factory HotelsDataModel.fromJson(Map<String, dynamic> json) {
    return HotelsDataModel(
      filters: (json['filters'] as List)
          .map((e) => FilterGroupModel.fromJson(e))
          .toList(),
      hotels:
          (json['items'] as List).map((e) => HotelModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': hotels.map((hotel) => hotel.toJson()).toList(),
      'filters': filters.map((filter) => filter.toJson()).toList(),
    };
  }
}
