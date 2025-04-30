import 'package:hotel_list_app/features/hotels/domain/entities/hotels_data.dart';
import 'package:hotel_list_app/features/hotels/domain/repositories/hotel_repository.dart';

class GetHotelsData {
  final HotelRepository repository;

  GetHotelsData(this.repository);

  Future<HotelsData> call({required int page}) async {
    return await repository.getHotelsData(page: page);
  }
}
