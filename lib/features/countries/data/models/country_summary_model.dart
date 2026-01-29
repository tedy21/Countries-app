class CountrySummary {
  final String name;
  final String flag;
  final int population;
  final String cca2;
  
  const CountrySummary({
    required this.name,
    required this.flag,
    required this.population,
    required this.cca2,
  });
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'flag': flag,
    'population': population,
    'cca2': cca2,
  };
}
