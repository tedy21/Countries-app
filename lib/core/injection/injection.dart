import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../features/countries/data/datasources/countries_remote_datasource.dart';
import '../../features/countries/data/datasources/countries_local_datasource.dart';
import '../../features/countries/data/repositories/countries_repository_impl.dart';
import '../../features/countries/domain/repositories/countries_repository.dart';
import '../../features/countries/domain/usecases/get_countries.dart';
import '../../features/countries/domain/usecases/get_country_by_id.dart';
import '../../features/countries/domain/usecases/search_countries.dart';
import '../../features/favorites/data/datasources/favorites_local_datasource.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/add_favorite.dart';
import '../../features/favorites/domain/usecases/remove_favorite.dart';
import '../../features/favorites/domain/usecases/toggle_favorite.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();

  final sharedPreferences = await SharedPreferences.getInstance();

  CacheStore? cacheStore;
  try {
    cacheStore = HiveCacheStore(
      null,
      hiveBoxName: 'dio_cache',
    );
  } catch (e) {
    cacheStore = null;
  }

  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(cacheStore: cacheStore));

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  getIt.registerLazySingleton<CountriesRemoteDataSource>(
    () => CountriesRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<CountriesLocalDataSource>(
    () => CountriesLocalDataSourceImpl(
        sharedPreferences: getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<CountriesRepository>(
    () => CountriesRepositoryImpl(
      remoteDataSource: getIt<CountriesRemoteDataSource>(),
      localDataSource: getIt<CountriesLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<CountriesRepositoryImpl>(
    () => getIt<CountriesRepository>() as CountriesRepositoryImpl,
  );

  getIt.registerLazySingleton<GetCountries>(
    () => GetCountries(getIt<CountriesRepository>()),
  );

  getIt.registerLazySingleton<GetCountryById>(
    () => GetCountryById(getIt<CountriesRepository>()),
  );

  getIt.registerLazySingleton<SearchCountries>(
    () => SearchCountries(getIt<CountriesRepository>()),
  );

  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      localDataSource: getIt<FavoritesLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<FavoritesRepositoryImpl>(
    () => getIt<FavoritesRepository>() as FavoritesRepositoryImpl,
  );

  getIt.registerLazySingleton<GetFavorites>(
    () => GetFavorites(getIt<FavoritesRepository>()),
  );

  getIt.registerLazySingleton<AddFavorite>(
    () => AddFavorite(getIt<FavoritesRepository>()),
  );

  getIt.registerLazySingleton<RemoveFavorite>(
    () => RemoveFavorite(getIt<FavoritesRepository>()),
  );

  getIt.registerLazySingleton<ToggleFavorite>(
    () => ToggleFavorite(getIt<FavoritesRepository>()),
  );
}
