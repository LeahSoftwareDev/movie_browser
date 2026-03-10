import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/favorites_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesBloc(this._repository) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<CheckFavoriteEvent>(_onCheckFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavoritesEvent event,
      Emitter<FavoritesState> emit,
      ) async {
    try {
      final favorites = _repository.getFavorites();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError(message: 'Failed to load favorites'));
    }
  }

  Future<void> _onAddFavorite(
      AddFavoriteEvent event,
      Emitter<FavoritesState> emit,
      ) async {
    try {
      await _repository.addFavorite(event.movie);
      final favorites = _repository.getFavorites();
      emit(FavoritesLoaded(favorites: favorites, isFavorite: true));
    } catch (e) {
      emit(FavoritesError(message: 'Failed to add favorite'));
    }
  }

  Future<void> _onRemoveFavorite(
      RemoveFavoriteEvent event,
      Emitter<FavoritesState> emit,
      ) async {
    try {
      await _repository.removeFavorite(event.imdbId);
      final favorites = _repository.getFavorites();
      emit(FavoritesLoaded(favorites: favorites, isFavorite: false));
    } catch (e) {
      emit(FavoritesError(message: 'Failed to remove favorite'));
    }
  }

  Future<void> _onCheckFavorite(
      CheckFavoriteEvent event,
      Emitter<FavoritesState> emit,
      ) async {
    final favorites = _repository.getFavorites();
    final isFavorite = _repository.isFavorite(event.imdbId);
    emit(FavoritesLoaded(favorites: favorites, isFavorite: isFavorite));
  }
}