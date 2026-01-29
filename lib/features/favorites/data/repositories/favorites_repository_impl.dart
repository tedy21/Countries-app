import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/favorite_country.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';
import '../models/favorite_country_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;
  
  FavoritesRepositoryImpl({required this.localDataSource});
  
  @override
  Future<Either<Failure, List<FavoriteCountry>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites.map((model) => model as FavoriteCountry).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> addFavorite(String countryId) async {
    try {
      final favorite = FavoriteCountryModel(
        countryId: countryId,
        favoritedAt: DateTime.now(),
      );
      await localDataSource.addFavorite(favorite);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> removeFavorite(String countryId) async {
    try {
      await localDataSource.removeFavorite(countryId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isFavorite(String countryId) async {
    try {
      final isFav = await localDataSource.isFavorite(countryId);
      return Right(isFav);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, bool>> toggleFavorite(String countryId) async {
    try {
      final isFavResult = await isFavorite(countryId);
      return isFavResult.fold(
        (failure) => Left(failure),
        (isFav) async {
          if (isFav) {
            final removeResult = await removeFavorite(countryId);
            return removeResult.fold(
              (failure) => Left(failure),
              (_) => const Right(false),
            );
          } else {
            final addResult = await addFavorite(countryId);
            return addResult.fold(
              (failure) => Left(failure),
              (_) => const Right(true),
            );
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
