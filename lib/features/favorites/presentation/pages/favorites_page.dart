import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/favorites_bloc.dart';
import '../widgets/favorite_list_item.dart';
import '../widgets/favorites_shimmer_loading.dart';
import '../../../countries/domain/entities/country.dart';
import '../../../countries/presentation/bloc/countries_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesInitial) {
          context.read<FavoritesBloc>().add(const GetFavoritesEvent());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favorites',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesInitial) {
              context.read<FavoritesBloc>().add(const GetFavoritesEvent());
              return const FavoritesShimmerLoading();
            }

            if (state is FavoritesLoading) {
              return const FavoritesShimmerLoading();
            }

            if (state is FavoritesError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Unable to load favorites',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<FavoritesBloc>()
                              .add(const GetFavoritesEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start adding countries to your favorites by tapping the heart icon',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final screenWidth = MediaQuery.of(context).size.width;
              final isTablet = screenWidth >= 600;
              final crossAxisCount = isTablet ? (screenWidth ~/ 300).clamp(2, 4) : 1;

              return isTablet
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: state.favorites.length,
                      itemBuilder: (context, index) {
                        final favorite = state.favorites[index];
                        return _FavoriteItemWithData(
                          favorite: favorite,
                          onRemove: () {
                            context.read<FavoritesBloc>().add(
                                  RemoveFavoriteEvent(favorite.countryId),
                                );
                          },
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.favorites.length,
                      itemBuilder: (context, index) {
                        final favorite = state.favorites[index];
                        return _FavoriteItemWithData(
                          favorite: favorite,
                          onRemove: () {
                            context.read<FavoritesBloc>().add(
                                  RemoveFavoriteEvent(favorite.countryId),
                                );
                          },
                        );
                      },
                    );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _FavoriteItemWithData extends StatefulWidget {
  final dynamic favorite;
  final VoidCallback onRemove;

  const _FavoriteItemWithData({
    required this.favorite,
    required this.onRemove,
  });

  @override
  State<_FavoriteItemWithData> createState() => _FavoriteItemWithDataState();
}

class _FavoriteItemWithDataState extends State<_FavoriteItemWithData> {
  Country? _country;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCountry();
    });
  }

  Future<void> _loadCountry() async {
    try {
      final countriesBloc = context.read<CountriesBloc>();
      final getCountryById = countriesBloc.getCountryById;

      final result = await getCountryById(widget.favorite.countryId);

      if (mounted) {
        result.fold(
          (failure) {
            setState(() {
              _isLoading = false;
            });
          },
          (country) {
            setState(() {
              _country = country;
              _isLoading = false;
            });
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _country == null) {
      final baseColor = Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade300
          : Colors.grey.shade700;
      final highlightColor = Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade100
          : Colors.grey.shade600;
      
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FavoriteListItem(
      favorite: widget.favorite,
      country: _country,
      onRemove: widget.onRemove,
    );
  }
}
