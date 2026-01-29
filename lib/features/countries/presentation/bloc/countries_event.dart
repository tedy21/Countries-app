part of 'countries_bloc.dart';

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();
  
  @override
  List<Object> get props => [];
}

class GetCountriesEvent extends CountriesEvent {
  const GetCountriesEvent();
}

class GetCountryByIdEvent extends CountriesEvent {
  final String id;
  
  const GetCountryByIdEvent(this.id);
  
  @override
  List<Object> get props => [id];
}

class SearchCountriesEvent extends CountriesEvent {
  final String query;
  
  const SearchCountriesEvent(this.query);
  
  @override
  List<Object> get props => [query];
}
