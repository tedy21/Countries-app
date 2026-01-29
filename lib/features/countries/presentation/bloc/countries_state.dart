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
  
  const CountriesLoaded(this.countries);
  
  @override
  List<Object> get props => [countries];
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
