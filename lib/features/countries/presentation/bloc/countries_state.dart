part of 'countries_bloc.dart';

abstract class CountriesState extends Equatable {
  const CountriesState();
  
  @override
  List<Object> get props => [];
}

class CountriesInitial extends CountriesState {
  const CountriesInitial();
}

class CountriesLoading extends CountriesState {
  const CountriesLoading();
}

class CountriesLoaded extends CountriesState {
  final List<Country> countries;
  final SortType? currentSort;
  
  const CountriesLoaded(this.countries, {this.currentSort});
  
  @override
  List<Object> get props => currentSort != null 
      ? [countries, currentSort!] 
      : [countries];
}

class CountryDetailLoaded extends CountriesState {
  final Country country;
  
  const CountryDetailLoaded(this.country);
  
  @override
  List<Object> get props => [country];
}

class CountriesError extends CountriesState {
  final String message;
  
  const CountriesError(this.message);
  
  @override
  List<Object> get props => [message];
}
