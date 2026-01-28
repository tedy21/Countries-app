part of 'countries_bloc.dart';

abstract class CountriesEvent extends Equatable {}

class GetCountriesEvent extends CountriesEvent {}

class GetCountryByIdEvent extends CountriesEvent {}

class SearchCountriesEvent extends CountriesEvent {}
