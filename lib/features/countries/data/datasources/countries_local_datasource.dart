import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/country_model.dart';

abstract class CountriesLocalDataSource {
  Future<List<CountryModel>> getCachedCountries();
  Future<CountryModel?> getCachedCountryById(String id);
  Future<void> cacheCountries(List<CountryModel> countries);
  Future<void> cacheCountry(CountryModel country);
  Future<void> clearCache();
}

class CountriesLocalDataSourceImpl implements CountriesLocalDataSource {
  static const String _countriesListKey = 'cached_countries_list';
  static const String _countryPrefix = 'cached_country_';
  
  final SharedPreferences sharedPreferences;
  
  CountriesLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<List<CountryModel>> getCachedCountries() async {
    try {
      final countriesJson = sharedPreferences.getStringList(_countriesListKey);
      if (countriesJson == null || countriesJson.isEmpty) {
        return [];
      }
      
      return countriesJson.map((jsonString) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return _jsonToCountryModel(json);
      }).toList();
    } catch (e) {
      throw CacheException('Failed to get cached countries: ${e.toString()}');
    }
  }
  
  @override
  Future<CountryModel?> getCachedCountryById(String id) async {
    try {
      final countryJson = sharedPreferences.getString('$_countryPrefix$id');
      if (countryJson == null) {
        return null;
      }
      
      final json = jsonDecode(countryJson) as Map<String, dynamic>;
      return _jsonToCountryModel(json);
    } catch (e) {
      return null;
    }
  }
  
  CountryModel _jsonToCountryModel(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      flag: json['flag'] as String?,
      capital: json['capital'] as String?,
      population: json['population'] as int?,
      area: json['area'] as double?,
      region: json['region'] as String?,
      subregion: json['subregion'] as String?,
      timezones: json['timezones'] != null 
          ? List<String>.from(json['timezones'] as List)
          : null,
    );
  }
  
  @override
  Future<void> cacheCountries(List<CountryModel> countries) async {
    try {
      final countriesJson = countries.map((country) {
        return jsonEncode({
          'id': country.id,
          'name': country.name,
          'code': country.code,
          'flag': country.flag,
          'capital': country.capital,
          'population': country.population,
          'area': country.area,
          'region': country.region,
          'subregion': country.subregion,
          'timezones': country.timezones,
        });
      }).toList();
      
      await sharedPreferences.setStringList(_countriesListKey, countriesJson);
    } catch (e) {
      throw CacheException('Failed to cache countries: ${e.toString()}');
    }
  }
  
  @override
  Future<void> cacheCountry(CountryModel country) async {
    try {
      final countryJson = jsonEncode({
        'id': country.id,
        'name': country.name,
        'code': country.code,
        'flag': country.flag,
        'capital': country.capital,
        'population': country.population,
        'area': country.area,
        'region': country.region,
        'subregion': country.subregion,
        'timezones': country.timezones,
      });
      
      await sharedPreferences.setString('$_countryPrefix${country.id}', countryJson);
    } catch (e) {
      throw CacheException('Failed to cache country: ${e.toString()}');
    }
  }
  
  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_countriesListKey);
      final keys = sharedPreferences.getKeys();
      for (final key in keys) {
        if (key.startsWith(_countryPrefix)) {
          await sharedPreferences.remove(key);
        }
      }
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
