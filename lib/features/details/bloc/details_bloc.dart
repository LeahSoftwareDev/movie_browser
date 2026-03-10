import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../data/repositories/details_repository.dart';
import 'details_event.dart';
import 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final DetailsRepository _repository;

  DetailsBloc(this._repository) : super(DetailsInitial()) {
    on<LoadMovieDetailsEvent>(_onLoadDetails);
  }

  Future<void> _onLoadDetails(
      LoadMovieDetailsEvent event,
      Emitter<DetailsState> emit,
      ) async {
    emit(DetailsLoading());

    try {
      final movie = await _repository.getMovieDetails(event.imdbId);
      emit(DetailsSuccess(movie: movie));
    } on NotFoundFailure catch (e) {
      emit(DetailsError(message: e.message));
    } on NetworkFailure {

      final cached = _repository.getCachedDetails(event.imdbId);
      if (cached != null) {
        emit(DetailsSuccess(movie: cached, isFromCache: true));
      } else {
        emit(DetailsError(message: 'No internet connection and no cached data available.'));
      }
    } catch (e) {
      emit(DetailsError(message: 'Something went wrong'));
    }
  }
}