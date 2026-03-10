import 'package:equatable/equatable.dart';
import '../data/models/movie_model.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  final List<String> history;

  SearchInitial({this.history = const []});

  @override
  List<Object?> get props => [history];
}

class SearchLoading extends SearchState {}

class SearchLoadingMore extends SearchState {
  final List<MovieModel> currentMovies;
  final String query;

  SearchLoadingMore({required this.currentMovies, required this.query});

  @override
  List<Object?> get props => [currentMovies, query];
}

class SearchSuccess extends SearchState {
  final List<MovieModel> movies;
  final String query;
  final bool isOffline;
  final bool hasMore;
  final int currentPage;

  SearchSuccess({
    required this.movies,
    required this.query,
    this.isOffline = false,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [movies, query, isOffline, hasMore, currentPage];
}

class SearchEmpty extends SearchState {
  final String query;

  SearchEmpty({required this.query});

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}