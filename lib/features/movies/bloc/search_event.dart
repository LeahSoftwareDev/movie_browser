import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchMoviesEvent extends SearchEvent {
  final String query;

  SearchMoviesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreMoviesEvent extends SearchEvent {}

class LoadSearchHistoryEvent extends SearchEvent {}

class ClearSearchHistoryEvent extends SearchEvent {}

class DeleteHistoryItemEvent extends SearchEvent {
  final String query;

  DeleteHistoryItemEvent(this.query);

  @override
  List<Object?> get props => [query];
}