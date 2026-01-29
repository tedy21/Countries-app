import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/favorite_country_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteCountryModel>> getFavorites();
  Future<void> addFavorite(FavoriteCountryModel favorite);
  Future<void> removeFavorite(String countryId);
  Future<bool> isFavorite(String countryId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  FavoritesLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<List<FavoriteCountryModel>> getFavorites() async {
    try {
      final favoritesJson = sharedPreferences.getStringList(AppConstants.favoritesStorageKey);
      if (favoritesJson == null || favoritesJson.isEmpty) {
        return [];
      }
      
      return favoritesJson.map((jsonString) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return FavoriteCountryModel(
          countryId: json['countryId'] as String,
          favoritedAt: DateTime.parse(json['favoritedAt'] as String),
        );
      }).toList();
    } catch (e) {
      throw CacheException('Failed to get favorites: ${e.toString()}');
    }
  }
  
  @override
  Future<void> addFavorite(FavoriteCountryModel favorite) async {
    try {
      final favorites = await getFavorites();
      
      if (favorites.any((f) => f.countryId == favorite.countryId)) {
        return;
      }
      
      favorites.add(favorite);
      await _saveFavorites(favorites);
    } catch (e) {
      throw CacheException('Failed to add favorite: ${e.toString()}');
    }
  }
  
  @override
  Future<void> removeFavorite(String countryId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((f) => f.countryId == countryId);
      await _saveFavorites(favorites);
    } catch (e) {
      throw CacheException('Failed to remove favorite: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> isFavorite(String countryId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((f) => f.countryId == countryId);
    } catch (e) {
      throw CacheException('Failed to check favorite status: ${e.toString()}');
    }
  }
  
  Future<void> _saveFavorites(List<FavoriteCountryModel> favorites) async {
    final favoritesJson = favorites.map((favorite) {
      return jsonEncode({
        'countryId': favorite.countryId,
        'favoritedAt': favorite.favoritedAt.toIso8601String(),
      });
    }).toList();
    
    await sharedPreferences.setStringList(
      AppConstants.favoritesStorageKey,
      favoritesJson,
    );
  }
}
