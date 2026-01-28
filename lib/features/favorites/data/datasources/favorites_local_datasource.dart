import '../../../../core/errors/exceptions.dart';
import '../models/favorite_country_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteCountryModel>> getFavorites();
  Future<void> addFavorite(FavoriteCountryModel favorite);
  Future<void> removeFavorite(String countryId);
  Future<bool> isFavorite(String countryId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
}
