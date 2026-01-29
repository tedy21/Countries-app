import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';
import '../../../../core/utils/number_formatter.dart';

class CountryListItem extends StatelessWidget {
  final Country country;
  final bool isFavorite;
  final bool showPopulation;
  final bool showFavoriteIcon;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const CountryListItem({
    super.key,
    required this.country,
    this.isFavorite = false,
    this.showPopulation = true,
    this.showFavoriteIcon = true,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Hero(
              tag: 'country_flag_${country.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: country.flag != null
                    ? Container(
                        width: 56,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image.network(
                          country.flag!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.flag, size: 24),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 56,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.flag, size: 24),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (showPopulation) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Population: ${country.population != null ? NumberFormatter.formatPopulation(country.population!) : 'N/A'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showFavoriteIcon)
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey.shade400,
                ),
                onPressed: onFavoriteTap,
              ),
          ],
        ),
      ),
    );
  }
}
