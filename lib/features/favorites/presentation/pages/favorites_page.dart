import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites_bloc.dart';
import '../widgets/favorite_list_item.dart';
import '../../../countries/domain/entities/country.dart';
import '../../../countries/data/mock_data/mock_countries_data.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  Country? _getCountryById(String countryId) {
    final details = MockCountriesData.getCountryDetails(countryId);
    if (details != null) {
      return Country(
        id: countryId,
        name: details.name,
        code: countryId,
        flag: details.flags,
        population: details.population,
        capital: details.capital.isNotEmpty ? details.capital.first : null,
        region: details.region,
        subregion: details.subregion,
        area: details.area,
        timezones: details.timezones,
      );
    }
    return null;
  }

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
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavoritesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FavoritesBloc>().add(const GetFavoritesEvent());
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
                  final country = _getCountryById(favorite.countryId);
                  return FavoriteListItem(
                    favorite: favorite,
                    country: country,
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
