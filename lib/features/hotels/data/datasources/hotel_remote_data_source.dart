import 'dart:convert';
import 'package:hotel_list_app/core/constants/status_code.dart';
import 'package:hotel_list_app/core/network/api_response.dart';
import 'package:hotel_list_app/core/network/config.dart';
import 'package:hotel_list_app/features/hotels/data/models/hotels_data_model.dart';
import 'package:http/http.dart' as http;

abstract class HotelRemoteDataSource {
  Future<ApiResponse<HotelsDataModel>> getHotelsData({required int page});
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  final bool simulateError;
  final Duration delay;
  static const int _perPage = 5;
  final http.Client client;

  HotelRemoteDataSourceImpl({
    this.simulateError = false,
    this.delay = const Duration(seconds: 2),
    required this.client,
  });

  @override
  Future<ApiResponse<HotelsDataModel>> getHotelsData(
      {required int page}) async {
    await Future.delayed(delay);
    if (simulateError) {
      return ApiResponse.error("Server error occurred. Please try again.",
          statusCode: 500);
    }
    try {
      final response = await client
          .get(Uri.parse('${AppConfig.baseUrl}/hotels.json'))
          .timeout(AppConfig.requestTimeout);
      if (response.statusCode == StatusCode.success) {
        final jsonMap = json.decode(response.body);
        final data = HotelsDataModel.fromJson(jsonMap);
        final start = (page - 1) * _perPage;
        final end = start + _perPage;
        final total = data.hotels.length;

        final slicedHotels = data.hotels.sublist(
          start,
          end > total ? total : end,
        );
        final pagedResult =
            HotelsDataModel(hotels: slicedHotels, filters: data.filters);
        return ApiResponse.success(pagedResult);
      } else {
        return ApiResponse.error("Server error",
            statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResponse.error("Failed to parse data: ${e.toString()}",
          statusCode: StatusCode.badRequest);
    }
  }
}
