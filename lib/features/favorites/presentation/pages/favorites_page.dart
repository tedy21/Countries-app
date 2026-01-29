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
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<FavoritesBloc>()
                            .add(const GetFavoritesEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) {
                return Center(
                  child: Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              }

              return ListView.builder(
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
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                decoration: const BoxDecoration(
                  color: Colors.white,
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
