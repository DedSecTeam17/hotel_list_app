import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/hotels_data.dart';
import 'package:hotel_list_app/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:hotel_list_app/features/hotels/domain/usecases/get_hotels_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_hotels_data_test.mocks.dart';

@GenerateMocks([HotelRepository])
void main() {
  late GetHotelsData useCase;
  late MockHotelRepository mockRepository;

  setUp(() {
    mockRepository = MockHotelRepository();
    useCase = GetHotelsData(mockRepository);
  });

  const tPage = 1;

  test('should return HotelsData from repository', () async {
    final mockHotelsData = HotelsData(hotels: [], filters: []);
    when(mockRepository.getHotelsData(page: anyNamed('page')))
        .thenAnswer((_) async => mockHotelsData);
    final result = await useCase(page: tPage);
    expect(result, mockHotelsData);
    verify(mockRepository.getHotelsData(page: tPage));
    verifyNoMoreInteractions(mockRepository);
  });
}
