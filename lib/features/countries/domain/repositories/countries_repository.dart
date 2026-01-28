import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/country.dart';

abstract class CountriesRepository {
  Future<Either<Failure, List<Country>>> getCountries();
  Future<Either<Failure, Country>> getCountryById(String id);
  Future<Either<Failure, List<Country>>> searchCountries(String query);
  Future<Either<Failure, List<Country>>> getCountriesPaginated({
    required int page,
    required int pageSize,
  });
}
