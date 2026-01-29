import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/country_model.dart';

abstract class CountriesRemoteDataSource {
  Future<List<CountryModel>> getCountries();
  Future<CountryModel> getCountryById(String id);
  Future<List<CountryModel>> searchCountries(String query);
}

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final ApiClient apiClient;
  
  CountriesRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await apiClient.get(
        ApiConstants.allCountriesEndpoint,
        queryParameters: {'fields': 'name,flags,population,cca2'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CountryModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException('Failed to fetch countries', statusCode: response.statusCode);
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
  
  @override
  Future<CountryModel> getCountryById(String id) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.getByCodeEndpoint}/$id',
        queryParameters: {
          'fields': 'name,flags,population,capital,region,subregion,area,timezones',
        },
      );
      
      if (response.statusCode == 200) {
        return CountryModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('Country not found', statusCode: response.statusCode);
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
  
  @override
  Future<List<CountryModel>> searchCountries(String query) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.searchByNameEndpoint}/$query',
        queryParameters: {'fields': 'name,flags,population,cca2'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isEmpty) {
          return [];
        }
        return data.map((json) => CountryModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException('Failed to search countries', statusCode: response.statusCode);
      }
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        return [];
      }
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}
