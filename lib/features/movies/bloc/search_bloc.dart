import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../data/repositories/movie_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<SearchMoviesEvent>(_onSearchMovies);
    on<LoadMoreMoviesEvent>(_onLoadMore);
    on<LoadSearchHistoryEvent>(_onLoadHistory);
    on<ClearSearchHistoryEvent>(_onClearHistory);
    on<DeleteHistoryItemEvent>(_onDeleteHistoryItem);
  }

  Future<void> _onSearchMovies(
      SearchMoviesEvent event,
      Emitter<SearchState> emit,
      ) async {
    if (event.query.trim().isEmpty) {
      emit(SearchError(message: 'Please enter a search term'));
      return;
    }

    emit(SearchLoading());

    try {
      final result = await _repository.searchMovies(event.query, page: 1);
      final movies = result.movies;
      final hasMore = result.hasMore;

      if (movies.isEmpty) {
        emit(SearchEmpty(query: event.query));
      } else {
        emit(SearchSuccess(
          movies: movies,
          query: event.query,
          hasMore: hasMore,
          currentPage: 1,
        ));
      }
    } on InvalidApiKeyFailure catch (e) {
      emit(SearchError(message: e.message));
    } on NotFoundFailure {
      emit(SearchEmpty(query: event.query));
    } on TimeoutFailure catch (e) {
      emit(SearchError(message: e.message));
    } on NetworkFailure {
      final cachedResults = _repository.getCachedResults(event.query);
      if (cachedResults.isNotEmpty) {
        emit(SearchSuccess(
          movies: cachedResults,
          query: event.query,
          isOffline: true,
          hasMore: false,
        ));
        return;
      }

      final favResults = _repository.searchInFavorites(event.query);
      if (favResults.isNotEmpty) {
        emit(SearchSuccess(
          movies: favResults,
          query: event.query,
          isOffline: true,
          hasMore: false,
        ));
        return;
      }

      emit(SearchError(message: 'No internet connection. No cached results found.'));
    } catch (e) {
      emit(SearchError(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onDeleteHistoryItem(
      DeleteHistoryItemEvent event,
      Emitter<SearchState> emit,
      ) async {
    await _repository.deleteHistoryItem(event.query);
    final history = _repository.getSearchHistory();
    emit(SearchInitial(history: history));
  }

  Future<void> _onLoadMore(
      LoadMoreMoviesEvent event,
      Emitter<SearchState> emit,
      ) async {
    final currentState = state;
    if (currentState is! SearchSuccess) return;
    if (!currentState.hasMore) return;

    emit(SearchLoadingMore(
      currentMovies: currentState.movies,
      query: currentState.query,
    ));

    try {
      final nextPage = currentState.currentPage + 1;
      final result = await _repository.searchMovies(
        currentState.query,
        page: nextPage,
      );

      final newMovies = result.movies;
      final hasMore = result.hasMore;//['hasMore'] as bool;

      emit(SearchSuccess(
        movies: [...currentState.movies, ...List.of(newMovies)],
        query: currentState.query,
        hasMore: hasMore,
        currentPage: nextPage,
      ));
    } on NetworkFailure {
      // אופליין – נשאר על התוצאות הנוכחיות
      emit(SearchSuccess(
        movies: currentState.movies,
        query: currentState.query,
        hasMore: false,
        currentPage: currentState.currentPage,
        isOffline: true,
      ));
    } catch (e) {
      emit(SearchError(message: 'Failed to load more movies'));
    }
  }

  Future<void> _onLoadHistory(
      LoadSearchHistoryEvent event,
      Emitter<SearchState> emit,
      ) async {
    final history = _repository.getSearchHistory();
    emit(SearchInitial(history: history));
  }

  Future<void> _onClearHistory(
      ClearSearchHistoryEvent event,
      Emitter<SearchState> emit,
      ) async {
    await _repository.clearHistory();
    emit(SearchInitial(history: []));
  }
}