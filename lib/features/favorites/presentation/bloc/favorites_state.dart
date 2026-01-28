part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
}

class FavoritesInitial extends FavoritesState {
}

class FavoritesLoading extends FavoritesState {
}

class FavoritesLoaded extends FavoritesState {
}

class FavoritesError extends FavoritesState {
}
