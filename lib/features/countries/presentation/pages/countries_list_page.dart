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
    return BlocListener<CountriesBloc, CountriesState>(
      listener: (context, state) {
        if (state is CountriesInitial) {
          context.read<CountriesBloc>().add(const GetCountriesEvent());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Countries',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
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
            Expanded(
              child: BlocBuilder<CountriesBloc, CountriesState>(
                builder: (context, state) {
                  if (state is CountriesInitial) {
                    context
                        .read<CountriesBloc>()
                        .add(const GetCountriesEvent());
                    return const ShimmerLoading();
                  }

                  if (state is CountriesLoading) {
                    return const ShimmerLoading();
                  }

                  if (state is CountriesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
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
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is CountriesLoaded) {
                    if (state.countries.isEmpty) {
                      return Center(
                        child: Text(
                          'No countries found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
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

                        return ListView.builder(
                          itemCount: state.countries.length,
                          itemBuilder: (context, index) {
                            final country = state.countries[index];
                            final isFavorite = favoriteIds.contains(country.id);

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
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
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
