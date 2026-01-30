import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/country.dart';

part 'country_model.freezed.dart';

@freezed
class CountryModel with _$CountryModel {
  const CountryModel._();

  const factory CountryModel({
    required String id,
    required String name,
    required String code,
    String? flag,
    String? capital,
    int? population,
    double? area,
    String? region,
    String? subregion,
    List<String>? timezones,
  }) = _CountryModel;

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final nameObj = json['name'] as Map<String, dynamic>?;
    final flagsObj = json['flags'] as Map<String, dynamic>?;
    final cca2 = json['cca2'] as String? ?? '';

    String? capitalValue;
    if (json['capital'] is List) {
      final capitalList = json['capital'] as List;
      capitalValue =
          capitalList.isNotEmpty ? capitalList.first.toString() : null;
    } else {
      capitalValue = json['capital']?.toString();
    }

    double? areaValue;
    if (json['area'] != null) {
      areaValue = json['area'] is int
          ? (json['area'] as int).toDouble()
          : json['area'] as double?;
    }

    return CountryModel(
      id: cca2,
      name: nameObj?['common'] as String? ?? '',
      code: cca2,
      flag: flagsObj?['png'] as String?,
      capital: capitalValue,
      population: json['population'] as int?,
      area: areaValue,
      region: json['region']?.toString(),
      subregion: json['subregion']?.toString(),
      timezones: json['timezones'] != null
          ? List<String>.from(json['timezones'])
          : null,
    );
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
