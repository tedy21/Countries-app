import '../../domain/entities/favorite_country.dart';

class MockFavoritesData {
  static List<FavoriteCountry> getFavorites() {
    return [
      FavoriteCountry(
        countryId: 'FR',
        favoritedAt: DateTime(2024, 1, 1),
      ),
      FavoriteCountry(
        countryId: 'JP',
        favoritedAt: DateTime(2024, 1, 2),
      ),
      FavoriteCountry(
        countryId: 'DE',
        favoritedAt: DateTime(2024, 1, 3),
      ),
      FavoriteCountry(
        countryId: 'IT',
        favoritedAt: DateTime(2024, 1, 4),
      ),
      FavoriteCountry(
        countryId: 'ES',
        favoritedAt: DateTime(2024, 1, 5),
      ),
    ];
  }
}
