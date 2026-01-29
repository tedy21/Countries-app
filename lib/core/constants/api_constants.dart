class ApiConstants {
  static const String baseUrl = 'https://restcountries.com/v3.1';
  static const String allCountriesEndpoint = '/all';
  static const String searchByNameEndpoint = '/name';
  static const String getByCodeEndpoint = '/alpha';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  static String getAllCountriesUrl() {
    return '$baseUrl$allCountriesEndpoint?fields=name,flags,population,cca2';
  }
  
  static String searchCountriesByNameUrl(String name) {
    return '$baseUrl$searchByNameEndpoint/$name?fields=name,flags,population,cca2';
  }
  
  static String getCountryByCodeUrl(String code) {
    return '$baseUrl$getByCodeEndpoint/$code?fields=name,flags,population,capital,region,subregion,area,timezones';
  }
}
