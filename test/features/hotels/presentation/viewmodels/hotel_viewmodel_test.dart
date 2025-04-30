import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/hotels_data.dart';
import 'package:hotel_list_app/features/hotels/domain/usecases/get_hotels_data.dart';
import 'package:hotel_list_app/features/hotels/presentation/viewmodels/hotel_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'hotel_viewmodel_test.mocks.dart';

@GenerateMocks([GetHotelsData])
void main() {
  late HotelViewModel viewModel;
  late MockGetHotelsData mockGetHotelsData;
  setUp(() {
    mockGetHotelsData = MockGetHotelsData();
    viewModel = HotelViewModel(getHotelsDataUseCase: mockGetHotelsData)
      ..initConnectivity(enable: false);
  });
  const tPage = 1;

  test('initial values should be correct', () {
    expect(viewModel.isLoading, false);
    expect(viewModel.hotels, []);
    expect(viewModel.filters, []);
    expect(viewModel.errorMessage, isNull);
  });

  group('loadHotelsData', () {
    test('should load hotels and filters successfully', () async {
      final hotelsData = HotelsData(hotels: [], filters: []);
      when(mockGetHotelsData(page: anyNamed('page')))
          .thenAnswer((_) async => hotelsData);
      await viewModel.loadHotelsData();
      expect(viewModel.isLoading, false);
      expect(viewModel.hotels, hotelsData.hotels);
      expect(viewModel.filters, hotelsData.filters);
      expect(viewModel.errorMessage, isNull);
      verify(mockGetHotelsData(page: 1)).called(1);
      verifyNoMoreInteractions(mockGetHotelsData);
    });

    test('should handle error properly', () async {
      when(mockGetHotelsData(page: anyNamed('page')))
          .thenThrow(Exception('Something went wrong'));
      await viewModel.loadHotelsData();
      expect(viewModel.isLoading, false);
      expect(viewModel.hotels, []);
      expect(viewModel.filters, []);
      expect(viewModel.errorMessage, isNotNull);
      verify(mockGetHotelsData(page: 1)).called(1);
      verifyNoMoreInteractions(mockGetHotelsData);
    });
  });
}
