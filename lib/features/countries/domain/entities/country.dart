import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String id;
  final String name;
  final String code;
  final String? flag;
  final String? capital;
  final int? population;
  final double? area;
  final String? region;
  final String? subregion;
  final List<String>? timezones;
  
  const Country({
    required this.id,
    required this.name,
    required this.code,
    this.flag,
    this.capital,
    this.population,
    this.area,
    this.region,
    this.subregion,
    this.timezones,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    code,
    flag,
    capital,
    population,
    area,
    region,
    subregion,
    timezones,
  ];
}
