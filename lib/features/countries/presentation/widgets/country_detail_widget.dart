import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';

class CountryDetailWidget extends StatelessWidget {
  final Country country;
  
  const CountryDetailWidget({
    super.key,
    required this.country,
  });
  
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
