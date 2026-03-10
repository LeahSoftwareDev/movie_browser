import 'package:equatable/equatable.dart';
import '../data/models/movie_details_model.dart';

abstract class DetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsSuccess extends DetailsState {
  final MovieDetailsModel movie;
  final bool isFromCache;

  DetailsSuccess({required this.movie, this.isFromCache = false,});

  @override
  List<Object?> get props => [movie, isFromCache];
}

class DetailsError extends DetailsState {
  final String message;

  DetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}