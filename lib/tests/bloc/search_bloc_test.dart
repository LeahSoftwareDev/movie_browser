import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_browser/features/movies/bloc/search_bloc.dart';
import 'package:movie_browser/features/movies/bloc/search_event.dart';
import 'package:movie_browser/features/movies/bloc/search_state.dart';
import 'package:movie_browser/features/movies/data/models/movie_model.dart';
import 'package:movie_browser/features/movies/data/repositories/movie_repository.dart';
import 'package:movie_browser/core/errors/failures.dart';


class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;
  late SearchBloc searchBloc;


  final fakeMovies = [
    MovieModel(
      imdbId: 'tt0372784',
      title: 'Batman Begins',
      year: '2005',
      poster: 'N/A',
      type: 'movie',
    ),
    MovieModel(
      imdbId: 'tt0468569',
      title: 'The Dark Knight',
      year: '2008',
      poster: 'N/A',
      type: 'movie',
    ),
  ];

  setUp(() {
    mockRepository = MockMovieRepository();
    searchBloc = SearchBloc(mockRepository);
  });

  tearDown(() {
    searchBloc.close();
  });

  group('SearchBloc', () {
    // Test 1 – valid search
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchSuccess] when search succeeds',
      build: () {
        when(() => mockRepository.searchMovies('batman', page: 1))
            .thenAnswer((_) async => (movies: fakeMovies, hasMore: false));
        return searchBloc;
      },
      act: (bloc) => bloc.add(SearchMoviesEvent('batman')),
      expect: () => [
        SearchLoading(),
        SearchSuccess(
          movies: fakeMovies,
          query: 'batman',
          hasMore: false,
          currentPage: 1,
        ),
      ],
    );

    // Test 2 – empty search
    blocTest<SearchBloc, SearchState>(
      'emits [SearchError] when query is empty',
      build: () => searchBloc,
      act: (bloc) => bloc.add(SearchMoviesEvent('')),
      expect: () => [
        isA<SearchError>(),
      ],
    );

    // Test 3 – no results
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchEmpty] when no results found',
      build: () {
        when(() => mockRepository.searchMovies('xyzxyzxyz', page: 1))
            .thenThrow(const NotFoundFailure('Movie not found'));
        return searchBloc;
      },
      act: (bloc) => bloc.add(SearchMoviesEvent('xyzxyzxyz')),
      expect: () => [
        SearchLoading(),
        isA<SearchEmpty>(),
      ],
    );

    // Test 4 – network error with cache
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchSuccess] with cached results when offline',
      build: () {
        when(() => mockRepository.searchMovies('batman', page: 1))
            .thenThrow(const NetworkFailure('No internet'));
        when(() => mockRepository.getCachedResults('batman'))
            .thenReturn(fakeMovies);
        return searchBloc;
      },
      act: (bloc) => bloc.add(SearchMoviesEvent('batman')),
      expect: () => [
        SearchLoading(),
        SearchSuccess(
          movies: fakeMovies,
          query: 'batman',
          isOffline: true,
          hasMore: false,
        ),
      ],
    );

    // Test 5 – network error without cache
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] when offline and no cache',
      build: () {
        when(() => mockRepository.searchMovies('batman', page: 1))
            .thenThrow(const NetworkFailure('No internet'));
        when(() => mockRepository.getCachedResults('batman'))
            .thenReturn([]);
        when(() => mockRepository.searchInFavorites('batman'))
            .thenReturn([]);
        return searchBloc;
      },
      act: (bloc) => bloc.add(SearchMoviesEvent('batman')),
      expect: () => [
        SearchLoading(),
        isA<SearchError>(),
      ],
    );

    // Test 6 – load history
    blocTest<SearchBloc, SearchState>(
      'emits [SearchInitial] with history when LoadSearchHistoryEvent added',
      build: () {
        when(() => mockRepository.getSearchHistory())
            .thenReturn(['batman', 'superman']);
        return searchBloc;
      },
      act: (bloc) => bloc.add(LoadSearchHistoryEvent()),
      expect: () => [
        SearchInitial(history: ['batman', 'superman']),
      ],
    );

    // Test 7 – delete history
    blocTest<SearchBloc, SearchState>(
      'emits [SearchInitial] with empty history when ClearSearchHistoryEvent added',
      build: () {
        when(() => mockRepository.clearHistory())
            .thenAnswer((_) async {});
        when(() => mockRepository.getSearchHistory())
            .thenReturn([]);
        return searchBloc;
      },
      act: (bloc) => bloc.add(ClearSearchHistoryEvent()),
      expect: () => [
        SearchInitial(history: []),
      ],
    );
  });
}


//flutter test tests/bloc/search_bloc_test.dart