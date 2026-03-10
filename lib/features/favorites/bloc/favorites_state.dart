import 'package:equatable/equatable.dart';
import '../../movies/data/models/movie_model.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<MovieModel> favorites;
  final bool isFavorite;

  FavoritesLoaded({
    required this.favorites,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [favorites, isFavorite];
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError({required this.message});

  @override
  List<Object?> get props => [message];
}