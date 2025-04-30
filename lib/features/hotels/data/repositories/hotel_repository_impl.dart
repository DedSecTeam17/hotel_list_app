import 'package:hotel_list_app/core/error/app_exception.dart';
import 'package:hotel_list_app/core/network/api_response.dart';
import 'package:hotel_list_app/features/hotels/data/datasources/hotel_local_data_source.dart';
import 'package:hotel_list_app/features/hotels/data/datasources/hotel_remote_data_source.dart';
import 'package:hotel_list_app/features/hotels/data/models/hotel_model.dart';
import 'package:hotel_list_app/features/hotels/data/models/hotels_data_model.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/filter.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/hotel.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/hotels_data.dart';
import 'package:hotel_list_app/features/hotels/domain/repositories/hotel_repository.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource remoteDataSource;
  final HotelLocalDataSource localDataSource;

  HotelRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<HotelsData> getHotelsData({required int page}) async {
    try {
      final ApiResponse response =
          await remoteDataSource.getHotelsData(page: page);
      if (!response.isSuccess || response.data == null) {
        throw AppException(
            response.errorMessage ?? "Unknown error", response.statusCode);
      }
      final remoteData = response.data!;
      await localDataSource.cacheHotelsData(remoteData);
      return _mapToDomain(remoteData!);
    } catch (e) {
      final cachedData = await localDataSource.getCachedHotelsData();
      if (cachedData != null) {
        return _mapToDomain(cachedData);
      }
      rethrow;
    }
  }

  HotelsDataModel _mergeWithoutDuplicates(
      HotelsDataModel? oldData, HotelsDataModel newData) {
    final oldHotels = oldData?.hotels ?? [];
    final newHotels = newData.hotels;

    final hotelMap = <String, HotelModel>{};

    for (final hotel in oldHotels) {
      hotelMap[hotel.name.toLowerCase()] = hotel;
    }

    for (final hotel in newHotels) {
      hotelMap[hotel.name.toLowerCase()] = hotel; // remote overwrites if exists
    }

    return HotelsDataModel(
        hotels: hotelMap.values.toList(), filters: newData.filters);
  }

  HotelsData _mapToDomain(HotelsDataModel dataModel) {
    return HotelsData(
      hotels: dataModel.hotels.map((hotel) {
        return Hotel(
          name: hotel.name,
          city: hotel.city,
          location: hotel.location,
          type: hotel.type,
          imageUrls: hotel.imageUrls,
          categories: hotel.categories.map((cat) {
            return HotelCategory(id: cat.id, name: cat.name);
          }).toList(),
          overviewText: hotel.overviewText,
          openingHours: hotel.openingHours,
          coordinates: hotel.coordinates,
          thingsToDo: hotel.thingsToDo.map((thing) {
            return HotelThingToDo(
              title: thing.title,
              subtitle: thing.subtitle,
              badge: thing.badge,
              content: thing.content
                  ?.map(
                    (group) => group
                        .map((item) => HotelTextContent(text: item.text))
                        .toList(),
                  )
                  .toList(),
              items: thing.items
                  ?.map(
                    (i) => HotelImageItem(imageUrl: i.imageUrl, title: i.title),
                  )
                  .toList(),
            );
          }).toList(),
        );
      }).toList(),
      filters: dataModel.filters.map((f) {
        return FilterGroup(
          name: f.name,
          categories: f.categories
              .map((c) => FilterCategory(id: c.id, name: c.name))
              .toList(),
        );
      }).toList(),
    );
  }
}
