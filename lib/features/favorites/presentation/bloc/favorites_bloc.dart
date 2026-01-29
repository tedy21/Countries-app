import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_country.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../../domain/usecases/toggle_favorite.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final ToggleFavorite toggleFavorite;
  
  FavoritesBloc({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
    required this.toggleFavorite,
  }) : super(const FavoritesInitial()) {
    on<GetFavoritesEvent>(_onGetFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }
  
  Future<void> _onGetFavorites(
    GetFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());
    final result = await getFavorites();
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }
  
  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await addFavorite(event.countryId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => add(const GetFavoritesEvent()),
    );
  }
  
  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await removeFavorite(event.countryId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => add(const GetFavoritesEvent()),
    );
  }
  
  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await toggleFavorite(event.countryId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => add(const GetFavoritesEvent()),
    );
  }
}
