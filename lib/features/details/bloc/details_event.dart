import 'package:equatable/equatable.dart';

abstract class DetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMovieDetailsEvent extends DetailsEvent {
  final String imdbId;

  LoadMovieDetailsEvent(this.imdbId);

  @override
  List<Object?> get props => [imdbId];
}