import '../../../../core/errors/exceptions.dart';
import '../models/country_model.dart';

abstract class CountriesLocalDataSource {
  Future<List<CountryModel>> getCachedCountries();
  Future<void> cacheCountries(List<CountryModel> countries);
  Future<void> clearCache();
}

class CountriesLocalDataSourceImpl implements CountriesLocalDataSource {
  @override
  Future<List<CountryModel>> getCachedCountries() async {
    throw const CacheException('No cached data available');
  }
  
  @override
  Future<void> cacheCountries(List<CountryModel> countries) async {
  }
  
  @override
  Future<void> clearCache() async {
  }
}
