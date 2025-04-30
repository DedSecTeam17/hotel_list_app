import 'package:get_it/get_it.dart';
import 'package:hotel_list_app/core/network/config.dart';
import 'package:hotel_list_app/core/network/fake_http_client.dart';
import 'package:hotel_list_app/core/network/http_ssl_pinning.dart';
import 'package:hotel_list_app/features/hotels/data/datasources/hotel_local_data_source.dart';
import 'features/hotels/data/datasources/hotel_remote_data_source.dart';
import 'features/hotels/data/repositories/hotel_repository_impl.dart';
import 'features/hotels/domain/usecases/get_hotels_data.dart';
import 'features/hotels/domain/repositories/hotel_repository.dart';
import 'features/hotels/presentation/viewmodels/hotel_viewmodel.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<http.Client>(() => AppConfig.isMock
      ? FakeHttpClient()
      : HttpSslPinning.createPinnedClient());
  sl.registerLazySingleton<HotelRemoteDataSource>(
    () => HotelRemoteDataSourceImpl(
      client: sl<http.Client>(),
    ),
  );
  sl.registerLazySingleton<HotelLocalDataSource>(
    () => HotelLocalDataSourceImpl(),
  );
  //  Repository
  sl.registerLazySingleton<HotelRepository>(
    () => HotelRepositoryImpl(
        sl<HotelRemoteDataSource>(), sl<HotelLocalDataSource>()),
  );
  // Usecases
  sl.registerLazySingleton(() => GetHotelsData(sl()));
  // ViewModels
  sl.registerFactory(() => HotelViewModel(getHotelsDataUseCase: sl()));
}
