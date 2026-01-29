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
    return CountryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      flag: json['flag']?.toString(),
      capital: json['capital']?.toString(),
      population: json['population'] as int?,
      area: json['area'] as double?,
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
