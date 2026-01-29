import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/countries_bloc.dart';
import '../widgets/country_list_item.dart';
import '../widgets/shimmer_loading.dart';

class CountriesListPage extends StatelessWidget {
  const CountriesListPage({super.key});

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
            _SearchField(),
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

                    return ListView.builder(
                      itemCount: state.countries.length,
                      itemBuilder: (context, index) {
                        final country = state.countries[index];
                        return CountryListItem(
                          country: country,
                          showPopulation: true,
                          showFavoriteIcon: true,
                          onTap: () {
                            context.push('/country/${country.id}');
                          },
                          onFavoriteTap: () {},
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
  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text;
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isEmpty) {
      context.read<CountriesBloc>().add(const GetCountriesEvent());
    } else {
      context.read<CountriesBloc>().add(SearchCountriesEvent(query));
    }
  }

  void _clearSearch() {
    _controller.clear();
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
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
        },
      ),
    );
  }
}
