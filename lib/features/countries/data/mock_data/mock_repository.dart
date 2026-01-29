import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/countries_repository.dart';
import 'mock_countries_data.dart';

class MockRepository implements CountriesRepository {
  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    await Future.delayed(const Duration(seconds: 1));
    
    final summaries = MockCountriesData.getCountriesSummary();
    final countries = summaries.map((summary) {
      return Country(
        id: summary.cca2,
        name: summary.name,
        code: summary.cca2,
        flag: summary.flag,
        population: summary.population,
      );
    }).toList();
    
    return Right(countries);
  }
  
  @override
  Future<Either<Failure, Country>> getCountryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final details = MockCountriesData.getCountryDetails(id);
    
    if (details == null) {
      return const Left(ServerFailure('Country not found'));
    }
    
    final country = Country(
      id: id,
      name: details.name,
      code: id,
      flag: details.flags,
      population: details.population,
      capital: details.capital.isNotEmpty ? details.capital.first : null,
      region: details.region,
      subregion: details.subregion,
      area: details.area,
      timezones: details.timezones,
    );
    
    return Right(country);
  }
  
  @override
  Future<Either<Failure, List<Country>>> searchCountries(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final summaries = MockCountriesData.getCountriesSummary();
    final queryLower = query.toLowerCase();
    
    final filtered = summaries
        .where((summary) => summary.name.toLowerCase().contains(queryLower))
        .map((summary) {
      return Country(
        id: summary.cca2,
        name: summary.name,
        code: summary.cca2,
        flag: summary.flag,
        population: summary.population,
      );
    }).toList();
    
    return Right(filtered);
  }
  
  @override
  Future<Either<Failure, List<Country>>> getCountriesPaginated({
    required int page,
    required int pageSize,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final summaries = MockCountriesData.getCountriesSummary();
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, summaries.length);
    
    if (startIndex >= summaries.length) {
      return const Right([]);
    }
    
    final paginated = summaries
        .sublist(startIndex, endIndex)
        .map((summary) {
      return Country(
        id: summary.cca2,
        name: summary.name,
        code: summary.cca2,
        flag: summary.flag,
        population: summary.population,
      );
    }).toList();
    
    return Right(paginated);
  }
}
