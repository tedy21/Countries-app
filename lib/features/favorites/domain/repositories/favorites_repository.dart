import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_country.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteCountry>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(String countryId);
  Future<Either<Failure, void>> removeFavorite(String countryId);
  Future<Either<Failure, bool>> isFavorite(String countryId);
  Future<Either<Failure, bool>> toggleFavorite(String countryId);
}
