import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/countries_bloc.dart';
import '../../domain/entities/country.dart';
import '../../../../core/utils/number_formatter.dart';
import '../widgets/detail_shimmer_loading.dart';

class CountryDetailPage extends StatelessWidget {
  final String countryId;

  const CountryDetailPage({
    super.key,
    required this.countryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CountriesBloc, CountriesState>(
      listener: (context, state) {
        if (state is CountriesInitial) {
          context.read<CountriesBloc>().add(GetCountryByIdEvent(countryId));
        }
      },
      child: BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
          String? countryName;
          if (state is CountryDetailLoaded) {
            countryName = state.country.name;
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                countryName ?? 'Country',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              centerTitle: false,
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
            ),
            body: SafeArea(
              child: _buildBody(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, CountriesState state) {
    if (state is CountriesInitial) {
      context.read<CountriesBloc>().add(GetCountryByIdEvent(countryId));
      return const DetailShimmerLoading();
    }

    if (state is CountriesLoading) {
      return const DetailShimmerLoading();
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
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
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<CountriesBloc>().add(
                        GetCountryByIdEvent(countryId),
                      );
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

    if (state is CountryDetailLoaded) {
      return _buildDetailContent(context, state.country);
    }

    return const DetailShimmerLoading();
  }

  Widget _buildDetailContent(BuildContext context, Country country) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'country_flag_${country.id}',
            child: Container(
              width: double.infinity,
              height: 250,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: country.flag != null
                    ? Image.network(
                        country.flag!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child:
                                Icon(Icons.flag, size: 64, color: Colors.white),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.flag, size: 64, color: Colors.white),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatRow(
                    context,
                    'Area',
                    country.area != null
                        ? NumberFormatter.formatArea(country.area!)
                        : 'N/A'),
                const SizedBox(height: 12),
                _buildStatRow(
                    context,
                    'Population',
                    country.population != null
                        ? NumberFormatter.formatPopulationForDetail(
                            country.population!)
                        : 'N/A'),
                const SizedBox(height: 12),
                _buildStatRow(context, 'Region', country.region ?? 'N/A'),
                const SizedBox(height: 12),
                _buildStatRow(
                    context, 'Sub Region', country.subregion ?? 'N/A'),
                const SizedBox(height: 32),
                Text(
                  'Timezone',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                if (country.timezones != null && country.timezones!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: country.timezones!.map((timezone) {
                      final formattedTimezone = _formatTimezone(timezone);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade100
                                  : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade300
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          formattedTimezone,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else
                  Text(
                    'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  String _formatTimezone(String timezone) {
    final regex = RegExp(r'UTC([+-])(\d{1,2}):00');
    final match = regex.firstMatch(timezone);
    if (match != null) {
      final sign = match.group(1)!;
      final hours = int.parse(match.group(2)!);
      return 'UTC $sign${hours.toString().padLeft(2, '0')}';
    }
    if (timezone.startsWith('UTC')) {
      return timezone.replaceAll(':', '').replaceAll('00', '');
    }
    return timezone;
  }
}
