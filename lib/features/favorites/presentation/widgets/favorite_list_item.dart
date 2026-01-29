import 'package:flutter/material.dart';
import '../../domain/entities/favorite_country.dart';
import '../../../countries/domain/entities/country.dart';

class FavoriteListItem extends StatelessWidget {
  final FavoriteCountry favorite;
  final Country? country;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;
  
  const FavoriteListItem({
    super.key,
    required this.favorite,
    this.country,
    this.onRemove,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: country?.flag != null
                  ? Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Image.network(
                        country!.flag!,
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
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.flag, size: 24),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country?.name ?? 'Country ${favorite.countryId}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (country?.capital != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Capital: ${country!.capital!}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: Colors.grey.shade400,
              ),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
