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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<CountriesBloc, CountriesState>(
            builder: (context, state) {
              if (state is CountriesInitial) {
                context
                    .read<CountriesBloc>()
                    .add(GetCountryByIdEvent(countryId));
                return const DetailShimmerLoading();
              }

              if (state is CountriesLoading) {
                return const DetailShimmerLoading();
              }

              if (state is CountriesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CountriesBloc>().add(
                                GetCountryByIdEvent(countryId),
                              );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is CountryDetailLoaded) {
                return _buildDetailContent(context, state.country);
              }

              return const DetailShimmerLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, Country country) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Text(
                  country.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 250,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Key Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatRow(
                    'Area',
                    country.area != null
                        ? NumberFormatter.formatArea(country.area!)
                        : 'N/A'),
                const SizedBox(height: 12),
                _buildStatRow(
                    'Population',
                    country.population != null
                        ? NumberFormatter.formatPopulationForDetail(
                            country.population!)
                        : 'N/A'),
                const SizedBox(height: 12),
                _buildStatRow('Region', country.region ?? 'N/A'),
                const SizedBox(height: 12),
                _buildStatRow('Sub Region', country.subregion ?? 'N/A'),
                const SizedBox(height: 32),
                const Text(
                  'Timezone',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          formattedTimezone,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else
                  const Text(
                    'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
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
    return timezone;
  }
}
