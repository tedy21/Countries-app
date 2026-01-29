class NumberFormatter {
  static String formatPopulation(int population) {
    if (population >= 1000000000) {
      return '${(population / 1000000000).toStringAsFixed(2)} billion';
    } else if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(2)} million';
    } else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)}K';
    }
    return population.toString();
  }

  static String formatArea(double area) {
    final formatted = area.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted sq km';
  }

  static String formatPopulationForDetail(int population) {
    if (population >= 1000000000) {
      return '${(population / 1000000000).toStringAsFixed(2)} billion';
    } else if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(2)} million';
    } else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)}K';
    }
    return population.toString();
  }
}
