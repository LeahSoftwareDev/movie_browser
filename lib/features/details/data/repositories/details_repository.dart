import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/hive_service.dart';
import '../models/movie_details_model.dart';

class DetailsRepository {
  final Dio _dio;

  DetailsRepository(this._dio);

  Future<MovieDetailsModel> getMovieDetails(String imdbId) async {
    // 1. בודק detailsCacheBox
    final cached = _getFromCache(imdbId);
    if (cached != null) return cached;

    // 2. מנסה API
    try {
      final response = await _dio.get(
        '/',
        queryParameters: {
          'i': imdbId,
          'plot': 'full',
        },
      );

      if (response.data['Response'] == 'False') {
        throw NotFoundFailure(response.data['Error'] ?? 'Movie not found');
      }

      final movie = MovieDetailsModel.fromJson(response.data);
      await _saveToCache(movie);
      return movie;

    } on DioException catch (e) {
      // 3. אופליין – בודק אם יש ב-favorites
      final fromFavorites = _getFromFavorites(imdbId);
      if (fromFavorites != null) return fromFavorites;

      throw NetworkFailure(e.message ?? 'Network error');
    }
  }

  MovieDetailsModel? getCachedDetails(String imdbId) {
    return _getFromCache(imdbId);
  }

  MovieDetailsModel? _getFromFavorites(String imdbId) {
    try {
      final movie = HiveService.favoritesBox.get(imdbId);
      if (movie == null) return null;

      // בונה MovieDetailsModel מתוך MovieModel
      return MovieDetailsModel(
        imdbId: movie.imdbId,
        title: movie.title,
        year: movie.year,
        type: movie.type,
        poster: movie.poster,
        plot: 'No internet connection – limited data available',
        director: 'N/A',
        actors: 'N/A',
        genre: 'N/A',
        runtime: 'N/A',
        imdbRating: 'N/A',
        language: 'N/A',
      );
    } catch (_) {
      return null;
    }
  }

  MovieDetailsModel? _getFromCache(String imdbId) {
    try {
      final box = HiveService.detailsCacheBox;
      return box.get(imdbId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToCache(MovieDetailsModel movie) async {
    try {
      final box = HiveService.detailsCacheBox;
      await box.put(movie.imdbId, movie);
    } catch (_) {}
  }
}