part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  
  @override
  List<Object> get props => [];
}

class GetFavoritesEvent extends FavoritesEvent {
  const GetFavoritesEvent();
}

class AddFavoriteEvent extends FavoritesEvent {
  final String countryId;
  
  const AddFavoriteEvent(this.countryId);
  
  @override
  List<Object> get props => [countryId];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final String countryId;
  
  const RemoveFavoriteEvent(this.countryId);
  
  @override
  List<Object> get props => [countryId];
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final String countryId;
  
  const ToggleFavoriteEvent(this.countryId);
  
  @override
  List<Object> get props => [countryId];
}
