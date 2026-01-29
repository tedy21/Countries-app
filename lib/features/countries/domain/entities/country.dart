import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String id;
  final String name;
  final String code;
  final String? flag;
  final String? capital;
  final int? population;
  final double? area;
  
  const Country({
    required this.id,
    required this.name,
    required this.code,
    this.flag,
    this.capital,
    this.population,
    this.area,
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
  ];
}
