import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/countries_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../widgets/country_list_item.dart';
import '../widgets/shimmer_loading.dart';

class CountriesListPage extends StatefulWidget {
  const CountriesListPage({super.key});

  @override
  State<CountriesListPage> createState() => _CountriesListPageState();
}

class _CountriesListPageState extends State<CountriesListPage> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Countries',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _SearchField(
            onSearchStateChanged: (isSearching) {
              setState(() {
                _isSearching = isSearching;
              });
            },
          ),
          BlocBuilder<CountriesBloc, CountriesState>(
            builder: (context, state) {
              if (state is CountriesLoaded &&
                  state.countries.isNotEmpty &&
                  !_isSearching) {
                return _SortBar(currentSort: state.currentSort);
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<CountriesBloc, CountriesState>(
              builder: (context, state) {
                if (state is CountriesInitial) {
                  return const ShimmerLoading();
                }

                if (state is CountriesLoading) {
                  return const ShimmerLoading();
                }

                if (state is CountriesError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Oops! Something went wrong',
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CountriesBloc>().add(
                                    const GetCountriesEvent(),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
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

                if (state is CountriesLoaded) {
                  if (state.countries.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No countries found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching with a different term',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, favoritesState) {
                      final favoriteIds = favoritesState is FavoritesLoaded
                          ? favoritesState.favorites
                              .map((f) => f.countryId)
                              .toSet()
                          : <String>{};

                      final screenWidth = MediaQuery.of(context).size.width;
                      final isTablet = screenWidth >= 600;
                      final crossAxisCount =
                          isTablet ? (screenWidth ~/ 300).clamp(2, 4) : 1;
                      final childAspectRatio = isTablet ? 2.5 : 0.0;

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<CountriesBloc>().add(
                                const GetCountriesEvent(),
                              );
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                        },
                        child: isTablet
                            ? GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: state.countries.length,
                                itemBuilder: (context, index) {
                                  final country = state.countries[index];
                                  final isFavorite =
                                      favoriteIds.contains(country.id);

                                  return CountryListItem(
                                    country: country,
                                    isFavorite: isFavorite,
                                    showPopulation: !_isSearching,
                                    showFavoriteIcon: !_isSearching,
                                    onTap: () {
                                      context.push('/country/${country.id}');
                                    },
                                    onFavoriteTap: () {
                                      context.read<FavoritesBloc>().add(
                                            ToggleFavoriteEvent(country.id),
                                          );
                                    },
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: state.countries.length,
                                itemBuilder: (context, index) {
                                  final country = state.countries[index];
                                  final isFavorite =
                                      favoriteIds.contains(country.id);

                                  return CountryListItem(
                                    country: country,
                                    isFavorite: isFavorite,
                                    showPopulation: !_isSearching,
                                    showFavoriteIcon: !_isSearching,
                                    onTap: () {
                                      context.push('/country/${country.id}');
                                    },
                                    onFavoriteTap: () {
                                      context.read<FavoritesBloc>().add(
                                            ToggleFavoriteEvent(country.id),
                                          );
                                    },
                                  );
                                },
                              ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  final Function(bool) onSearchStateChanged;

  const _SearchField({required this.onSearchStateChanged});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.trim();
    final isSearching = query.isNotEmpty;
    setState(() {
      _isSearching = isSearching;
    });
    widget.onSearchStateChanged(isSearching);

    _debounceTimer?.cancel();

    if (query.isEmpty) {
      context.read<CountriesBloc>().add(const GetCountriesEvent());
    } else {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.read<CountriesBloc>().add(SearchCountriesEvent(query));
        }
      });
    }
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _controller.clear();
    widget.onSearchStateChanged(false);
    context.read<CountriesBloc>().add(const GetCountriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search for a country',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

class _SortBar extends StatelessWidget {
  final SortType? currentSort;

  const _SortBar({this.currentSort});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Sort by:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                _SortButton(
                  label: 'Name',
                  sortType: SortType.name,
                  isSelected: currentSort == SortType.name,
                ),
                const SizedBox(width: 8),
                _SortButton(
                  label: 'Population',
                  sortType: SortType.population,
                  isSelected: currentSort == SortType.population,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String label;
  final SortType sortType;
  final bool isSelected;

  const _SortButton({
    required this.label,
    required this.sortType,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CountriesBloc>().add(SortCountriesEvent(sortType));
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
