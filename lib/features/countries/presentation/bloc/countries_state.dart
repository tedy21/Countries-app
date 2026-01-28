part of 'countries_bloc.dart';

abstract class CountriesState extends Equatable {}

class CountriesInitial extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {}

class CountryDetailLoaded extends CountriesState {}

class CountriesError extends CountriesState {}
