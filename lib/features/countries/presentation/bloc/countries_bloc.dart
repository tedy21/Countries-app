import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/country.dart';
import '../../domain/usecases/get_countries.dart';
import '../../domain/usecases/get_country_by_id.dart';
import '../../domain/usecases/search_countries.dart';

part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final GetCountries getCountries;
  final GetCountryById getCountryById;
  final SearchCountries searchCountries;
  
  CountriesBloc({
    required this.getCountries,
    required this.getCountryById,
    required this.searchCountries,
  }) : super(CountriesInitial()) {
    on<GetCountriesEvent>(_onGetCountries);
    on<GetCountryByIdEvent>(_onGetCountryById);
    on<SearchCountriesEvent>(_onSearchCountries);
  }
  
  Future<void> _onGetCountries(
    GetCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    emit(CountriesLoading());
    final result = await getCountries();
    result.fold(
      (failure) => emit(CountriesError(failure.message)),
      (countries) => emit(CountriesLoaded(countries)),
    );
  }
  
  Future<void> _onGetCountryById(
    GetCountryByIdEvent event,
    Emitter<CountriesState> emit,
  ) async {
    emit(CountriesLoading());
    final result = await getCountryById(event.id);
    result.fold(
      (failure) => emit(CountriesError(failure.message)),
      (country) => emit(CountryDetailLoaded(country)),
    );
  }
  
  Future<void> _onSearchCountries(
    SearchCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    emit(CountriesLoading());
    final result = await searchCountries(event.query);
    result.fold(
      (failure) => emit(CountriesError(failure.message)),
      (countries) => emit(CountriesLoaded(countries)),
    );
  }
}
