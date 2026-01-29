import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class SearchCountries {
  final CountriesRepository repository;
  
  SearchCountries(this.repository);
  
  Future<Either<Failure, List<Country>>> call(String query) async {
    return await repository.searchCountries(query);
  }
}
