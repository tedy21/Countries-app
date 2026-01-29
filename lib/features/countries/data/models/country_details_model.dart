class CountryDetails {
  final String name;
  final String flags;
  final int population;
  final List<String> capital;
  final String region;
  final String subregion;
  final double area;
  final List<String> timezones;
  
  const CountryDetails({
    required this.name,
    required this.flags,
    required this.population,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.area,
    required this.timezones,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'flags': flags,
    'population': population,
    'capital': capital,
    'region': region,
    'subregion': subregion,
    'area': area,
    'timezones': timezones,
  };
}
