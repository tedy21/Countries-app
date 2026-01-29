import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class GetCountries {
  final CountriesRepository repository;
  
  GetCountries(this.repository);
  
  Future<Either<Failure, List<Country>>> call() async {
    return await repository.getCountries();
  }
}
