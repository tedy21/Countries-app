import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/country_model.dart';

abstract class CountriesRemoteDataSource {
  Future<List<CountryModel>> getCountries();
  Future<CountryModel> getCountryById(String id);
  Future<List<CountryModel>> searchCountries(String query);
}

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {}
