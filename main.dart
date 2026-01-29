import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart' hide State;
import 'lib/features/countries/presentation/pages/countries_list_page.dart';
import 'lib/features/favorites/presentation/pages/favorites_page.dart';
import 'lib/core/widgets/bottom_navigation.dart';
import 'lib/features/countries/presentation/bloc/countries_bloc.dart';
import 'lib/features/countries/domain/usecases/get_countries.dart';
import 'lib/features/countries/domain/usecases/get_country_by_id.dart';
import 'lib/features/countries/domain/usecases/search_countries.dart';
import 'lib/features/countries/domain/repositories/countries_repository.dart';
import 'lib/features/countries/domain/entities/country.dart';
import 'lib/core/errors/failures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          BlocProvider(
            create: (context) {
              // TODO: Replace with actual repository implementation
              // For now, create a mock bloc that will need proper setup
              return CountriesBloc(
                getCountries: GetCountries(_MockRepository()),
                getCountryById: GetCountryById(_MockRepository()),
                searchCountries: SearchCountries(_MockRepository()),
              );
            },
            child: const CountriesListPage(),
          ),
          const FavoritesPage(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// Temporary mock repository for UI development
class _MockRepository implements CountriesRepository {
  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    // This will be replaced with actual implementation
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Country>> getCountryById(String id) async {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<Country>>> searchCountries(String query) async {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<Country>>> getCountriesPaginated({
    required int page,
    required int pageSize,
  }) async {
    throw UnimplementedError();
  }
}
