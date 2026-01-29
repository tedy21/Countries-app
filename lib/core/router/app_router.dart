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
import '../../features/countries/data/mock_data/mock_repository.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/add_favorite.dart';
import '../../features/favorites/domain/usecases/remove_favorite.dart';
import '../../features/favorites/domain/usecases/toggle_favorite.dart';
import '../../features/favorites/data/mock_data/mock_favorites_repository.dart';
import '../widgets/bottom_navigation.dart';

class AppRouter {
  static final MockRepository _mockRepository = MockRepository();
  static final MockFavoritesRepository _mockFavoritesRepository = MockFavoritesRepository();
  
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
            builder: (context, state) => BlocProvider(
              create: (context) => CountriesBloc(
                getCountries: GetCountries(_mockRepository),
                getCountryById: GetCountryById(_mockRepository),
                searchCountries: SearchCountries(_mockRepository),
              ),
              child: const CountriesListPage(),
            ),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => BlocProvider(
              create: (context) => FavoritesBloc(
                getFavorites: GetFavorites(_mockFavoritesRepository),
                addFavorite: AddFavorite(_mockFavoritesRepository),
                removeFavorite: RemoveFavorite(_mockFavoritesRepository),
                toggleFavorite: ToggleFavorite(_mockFavoritesRepository),
              ),
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
              getCountries: GetCountries(_mockRepository),
              getCountryById: GetCountryById(_mockRepository),
              searchCountries: SearchCountries(_mockRepository),
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
