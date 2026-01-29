import '../../domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.id,
    required super.name,
    required super.code,
    super.flag,
    super.capital,
    super.population,
    super.area,
    super.region,
    super.subregion,
    super.timezones,
  });
  
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final nameObj = json['name'] as Map<String, dynamic>?;
    final flagsObj = json['flags'] as Map<String, dynamic>?;
    final cca2 = json['cca2'] as String? ?? '';
    
    return CountryModel(
      id: cca2,
      name: nameObj?['common'] as String? ?? '',
      code: cca2,
      flag: flagsObj?['png'] as String?,
      capital: json['capital'] is List 
          ? (json['capital'] as List).isNotEmpty 
              ? (json['capital'] as List).first.toString()
              : null
          : json['capital']?.toString(),
      population: json['population'] as int?,
      area: json['area'] is int 
          ? (json['area'] as int).toDouble()
          : json['area'] as double?,
      region: json['region']?.toString(),
      subregion: json['subregion']?.toString(),
      timezones: json['timezones'] != null 
          ? List<String>.from(json['timezones'])
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'flag': flag,
      'capital': capital,
      'population': population,
      'area': area,
      'region': region,
      'subregion': subregion,
      'timezones': timezones,
    };
  }
  
  Country toEntity() {
    return Country(
      id: id,
      name: name,
      code: code,
      flag: flag,
      capital: capital,
      population: population,
      area: area,
      region: region,
      subregion: subregion,
      timezones: timezones,
    );
  }
}
