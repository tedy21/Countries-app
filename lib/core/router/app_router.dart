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
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/add_favorite.dart';
import '../../features/favorites/domain/usecases/remove_favorite.dart';
import '../../features/favorites/domain/usecases/toggle_favorite.dart';
import '../injection/injection.dart';
import '../widgets/bottom_navigation.dart';

class AppRouter {
  static void initialize() {}

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
            builder: (context, state) => const CountriesListPage(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/country/:id',
        builder: (context, state) {
          final countryId = state.pathParameters['id']!;
          return BlocProvider(
            create: (context) => CountriesBloc(
              getCountries: getIt<GetCountries>(),
              getCountryById: getIt<GetCountryById>(),
              searchCountries: getIt<SearchCountries>(),
            ),
            child: CountryDetailPage(countryId: countryId),
          );
        },
      ),
    ],
  );
}

class _MainShell extends StatefulWidget {
  final Widget child;

  const _MainShell({required this.child});

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  late final CountriesBloc _countriesBloc;
  late final FavoritesBloc _favoritesBloc;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _countriesBloc = CountriesBloc(
      getCountries: getIt<GetCountries>(),
      getCountryById: getIt<GetCountryById>(),
      searchCountries: getIt<SearchCountries>(),
    );
    _favoritesBloc = FavoritesBloc(
      getFavorites: getIt<GetFavorites>(),
      addFavorite: getIt<AddFavorite>(),
      removeFavorite: getIt<RemoveFavorite>(),
      toggleFavorite: getIt<ToggleFavorite>(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize data only once when the shell is first built
    if (!_hasInitialized) {
      _hasInitialized = true;
      _countriesBloc.add(const GetCountriesEvent());
      _favoritesBloc.add(const GetFavoritesEvent());
    }
  }

  @override
  void dispose() {
    _countriesBloc.close();
    _favoritesBloc.close();
    super.dispose();
  }

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

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _countriesBloc),
        BlocProvider.value(value: _favoritesBloc),
      ],
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: AppBottomNavigation(
          currentIndex: currentIndex,
          onTap: (index) => _onTabTapped(index, context),
        ),
      ),
    );
  }
}
