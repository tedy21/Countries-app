import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/countries/presentation/pages/countries_list_page.dart';
import '../../features/countries/presentation/pages/country_detail_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/countries/presentation/bloc/countries_bloc.dart';
import '../../features/countries/domain/usecases/get_countries.dart';
import '../../features/countries/domain/usecases/get_country_by_id.dart';
import '../../features/countries/domain/usecases/search_countries.dart';
import '../../features/countries/data/repositories/countries_repository_impl.dart';
import '../../features/countries/data/datasources/countries_remote_datasource.dart';
import '../../features/countries/data/datasources/countries_local_datasource.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/add_favorite.dart';
import '../../features/favorites/domain/usecases/remove_favorite.dart';
import '../../features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/data/datasources/favorites_local_datasource.dart';
import '../widgets/bottom_navigation.dart';

class AppRouter {
  static final ApiClient _apiClient = ApiClient();
  static final NetworkInfo _networkInfo = NetworkInfoImpl();
  static final CountriesRemoteDataSource _remoteDataSource =
      CountriesRemoteDataSourceImpl(apiClient: _apiClient);
  static final CountriesLocalDataSource _localDataSource =
      CountriesLocalDataSourceImpl();
  static final CountriesRepositoryImpl _countriesRepository =
      CountriesRepositoryImpl(
    remoteDataSource: _remoteDataSource,
    localDataSource: _localDataSource,
    networkInfo: _networkInfo,
  );

  static FavoritesRepositoryImpl? _favoritesRepository;

  static void initialize(SharedPreferences sharedPreferences) {
    final favoritesLocalDataSource = FavoritesLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    _favoritesRepository = FavoritesRepositoryImpl(
      localDataSource: favoritesLocalDataSource,
    );
  }

  static FavoritesRepositoryImpl get _favoritesRepo {
    if (_favoritesRepository == null) {
      throw StateError(
          'AppRouter not initialized. Call AppRouter.initialize() first.');
    }
    return _favoritesRepository!;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return _MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => CountriesBloc(
                    getCountries: GetCountries(_countriesRepository),
                    getCountryById: GetCountryById(_countriesRepository),
                    searchCountries: SearchCountries(_countriesRepository),
                  ),
                ),
                BlocProvider(
                  create: (context) => FavoritesBloc(
                    getFavorites: GetFavorites(_favoritesRepo),
                    addFavorite: AddFavorite(_favoritesRepo),
                    removeFavorite: RemoveFavorite(_favoritesRepo),
                    toggleFavorite: ToggleFavorite(_favoritesRepo),
                  )..add(const GetFavoritesEvent()),
                ),
              ],
              child: const CountriesListPage(),
            ),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => FavoritesBloc(
                    getFavorites: GetFavorites(_favoritesRepo),
                    addFavorite: AddFavorite(_favoritesRepo),
                    removeFavorite: RemoveFavorite(_favoritesRepo),
                    toggleFavorite: ToggleFavorite(_favoritesRepo),
                  ),
                ),
                BlocProvider(
                  create: (context) => CountriesBloc(
                    getCountries: GetCountries(_countriesRepository),
                    getCountryById: GetCountryById(_countriesRepository),
                    searchCountries: SearchCountries(_countriesRepository),
                  ),
                ),
              ],
              child: const FavoritesPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/country/:id',
        builder: (context, state) {
          final countryId = state.pathParameters['id']!;
          return BlocProvider(
            create: (context) => CountriesBloc(
              getCountries: GetCountries(_countriesRepository),
              getCountryById: GetCountryById(_countriesRepository),
              searchCountries: SearchCountries(_countriesRepository),
            ),
            child: CountryDetailPage(countryId: countryId),
          );
        },
      ),
    ],
  );
}

class _MainShell extends StatelessWidget {
  final Widget child;

  const _MainShell({required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == '/home') return 0;
    if (location == '/favorites') return 1;
    return 0;
  }

  void _onTabTapped(int index, BuildContext context) {
    if (index == 0) {
      context.go('/home');
    } else if (index == 1) {
      context.go('/favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) => _onTabTapped(index, context),
      ),
    );
  }
}
