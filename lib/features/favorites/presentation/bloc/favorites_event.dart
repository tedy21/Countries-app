part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
}

class GetFavoritesEvent extends FavoritesEvent {
}

class AddFavoriteEvent extends FavoritesEvent {
}

class RemoveFavoriteEvent extends FavoritesEvent {
}

class ToggleFavoriteEvent extends FavoritesEvent {
}
