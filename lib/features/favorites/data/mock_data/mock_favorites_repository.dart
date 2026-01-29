import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/favorite_country.dart';
import '../../domain/repositories/favorites_repository.dart';
import 'mock_favorites_data.dart';

class MockFavoritesRepository implements FavoritesRepository {
  List<FavoriteCountry> _favorites = [];
  
  MockFavoritesRepository() {
    _favorites = MockFavoritesData.getFavorites();
  }
  
  @override
  Future<Either<Failure, List<FavoriteCountry>>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(List.from(_favorites));
  }
  
  @override
  Future<Either<Failure, void>> addFavorite(String countryId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_favorites.any((f) => f.countryId == countryId)) {
      _favorites.add(FavoriteCountry(
        countryId: countryId,
        favoritedAt: DateTime.now(),
      ));
    }
    return const Right(null);
  }
  
  @override
  Future<Either<Failure, void>> removeFavorite(String countryId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _favorites.removeWhere((f) => f.countryId == countryId);
    return const Right(null);
  }
  
  @override
  Future<Either<Failure, bool>> isFavorite(String countryId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return Right(_favorites.any((f) => f.countryId == countryId));
  }
  
  @override
  Future<Either<Failure, bool>> toggleFavorite(String countryId) async {
    final isFav = await isFavorite(countryId);
    return isFav.fold(
      (failure) => Left(failure),
      (isFav) async {
        if (isFav) {
          return await removeFavorite(countryId).then((_) => const Right(false));
        } else {
          return await addFavorite(countryId).then((_) => const Right(true));
        }
      },
    );
  }
}
