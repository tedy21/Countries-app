import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class GetCountryById {
  final CountriesRepository repository;
  
  GetCountryById(this.repository);
  
  Future<Either<Failure, Country>> call(String id) async {
    return await repository.getCountryById(id);
  }
}
