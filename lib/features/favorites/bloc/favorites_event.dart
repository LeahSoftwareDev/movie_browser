import 'package:equatable/equatable.dart';
import '../../movies/data/models/movie_model.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class AddFavoriteEvent extends FavoritesEvent {
  final MovieModel movie;

  AddFavoriteEvent(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final String imdbId;

  RemoveFavoriteEvent(this.imdbId);

  @override
  List<Object?> get props => [imdbId];
}

class CheckFavoriteEvent extends FavoritesEvent {
  final String imdbId;

  CheckFavoriteEvent(this.imdbId);

  @override
  List<Object?> get props => [imdbId];
}