import 'package:hotel_list_app/features/hotels/domain/entities/hotels_data.dart';

abstract class HotelRepository {
  Future<HotelsData> getHotelsData({required int page});
}
