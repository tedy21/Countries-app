import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/countries_repository.dart';
import '../datasources/countries_local_datasource.dart';
import '../datasources/countries_remote_datasource.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource remoteDataSource;
  final CountriesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  CountriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCountries = await remoteDataSource.getCountries();
        final countries = remoteCountries.map((model) => model.toEntity()).toList();
        return Right(countries);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, Country>> getCountryById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCountry = await remoteDataSource.getCountryById(id);
        return Right(remoteCountry.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<Country>>> searchCountries(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCountries = await remoteDataSource.searchCountries(query);
        final countries = remoteCountries.map((model) => model.toEntity()).toList();
        return Right(countries);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<Country>>> getCountriesPaginated({
    required int page,
    required int pageSize,
  }) async {
    final result = await getCountries();
    return result.fold(
      (failure) => Left(failure),
      (countries) {
        final startIndex = page * pageSize;
        final endIndex = (startIndex + pageSize).clamp(0, countries.length);
        
        if (startIndex >= countries.length) {
          return const Right([]);
        }
        
        return Right(countries.sublist(startIndex, endIndex));
      },
    );
  }
}
