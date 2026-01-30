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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    
    if (isTablet) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'country_flag_${country.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: country.flag != null
                      ? Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            country.flag!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: Icon(
                                  Icons.flag,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.flag,
                            size: 48,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      country.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (showFavoriteIcon)
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                      ),
                      onPressed: onFavoriteTap,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              if (showPopulation) ...[
                const SizedBox(height: 4),
                Text(
                  'Population: ${country.population != null ? NumberFormatter.formatPopulation(country.population!) : 'N/A'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
    
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
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image.network(
                          country.flag!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Icon(
                                Icons.flag,
                                size: 24,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 56,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.flag,
                          size: 24,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                        ),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (showPopulation) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Population: ${country.population != null ? NumberFormatter.formatPopulation(country.population!) : 'N/A'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                  color: isFavorite ? Colors.red : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
                onPressed: onFavoriteTap,
              ),
          ],
        ),
      ),
    );
  }
}
