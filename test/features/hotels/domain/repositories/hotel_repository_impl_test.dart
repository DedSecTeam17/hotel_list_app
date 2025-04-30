import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/core/network/api_response.dart';
import 'package:hotel_list_app/features/hotels/data/datasources/hotel_local_data_source.dart';
import 'package:hotel_list_app/features/hotels/data/datasources/hotel_remote_data_source.dart';
import 'package:hotel_list_app/features/hotels/data/models/hotels_data_model.dart';
import 'package:hotel_list_app/features/hotels/data/repositories/hotel_repository_impl.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/hotels_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'hotel_repository_impl_test.mocks.dart';

@GenerateMocks([HotelRemoteDataSource, HotelLocalDataSource])
void main() {
  late HotelRepositoryImpl repository;
  late MockHotelRemoteDataSource mockRemoteDataSource;
  late MockHotelLocalDataSource mockHotelLocalDataSource;
  const tPage = 1;

  setUp(() {
    mockRemoteDataSource = MockHotelRemoteDataSource();
    mockHotelLocalDataSource = MockHotelLocalDataSource();
    repository =
        HotelRepositoryImpl(mockRemoteDataSource, mockHotelLocalDataSource);
  });

  group('HotelRepositoryImpl', () {
    test('should return HotelsData when RemoteDataSource succeeds', () async {
      final hotelsDataModel = HotelsDataModel(
        hotels: [],
        filters: [],
      );
      when(mockRemoteDataSource.getHotelsData(page: tPage))
          .thenAnswer((_) async => ApiResponse.success(hotelsDataModel));

      when(mockHotelLocalDataSource.getCachedHotelsData())
          .thenAnswer((_) async => HotelsDataModel(hotels: [], filters: []));

      final result = await repository.getHotelsData(page: tPage);
      expect(result, isA<HotelsData>());
      verify(mockRemoteDataSource.getHotelsData(page: tPage));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw Exception when RemoteDataSource returns error',
        () async {
      when(mockRemoteDataSource.getHotelsData(page: tPage)).thenAnswer(
          (_) async =>
              ApiResponse.error('Something went wrong', statusCode: 500));
      when(mockHotelLocalDataSource.getCachedHotelsData())
          .thenAnswer((_) async => HotelsDataModel(hotels: [], filters: []));
      final result = await repository.getHotelsData(page: tPage);
      expect(result.hotels, isEmpty);
      verify(mockRemoteDataSource.getHotelsData(page: tPage));
      verify(mockHotelLocalDataSource.getCachedHotelsData());
    });
  });
}
