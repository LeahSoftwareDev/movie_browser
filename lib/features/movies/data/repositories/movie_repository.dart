import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/hive_service.dart';
import '../models/movie_model.dart';

class MovieRepository {
  final Dio _dio;

  MovieRepository(this._dio);

  Future<({List<MovieModel> movies, bool hasMore})> searchMovies(
      String query, {
        int page = 1,
      }) async {
    try {
      final response = await _dio.get(
        '/',
        queryParameters: {
          's': query,
          'type': 'movie',
          'page': page,
        },
      );

      if (response.data['Response'] == 'False') {
        final error = response.data['Error'] ?? '';
        if (error.contains('Invalid API key')) throw const InvalidApiKeyFailure();
        throw NotFoundFailure(error.isNotEmpty ? error : 'No movies found');
      }

      final List results = response.data['Search'];
      final int totalResults = int.tryParse(
        response.data['totalResults'] ?? '0',
      ) ?? 0;
      final movies = results.map((e) => MovieModel.fromJson(e)).toList();

      if (page == 1) {
        await _saveToHistory(query);
        await _saveSearchResults(query, movies);
      }

      return (
      movies: movies,
      hasMore: (page * 10) < totalResults,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutFailure();
      }
      throw NetworkFailure(e.message ?? 'Network error');
    }
  }


  Future<void> _saveToHistory(String query) async {
    final box = HiveService.searchHistoryBox;
    final history = box.values.toList();

    if (history.contains(query)) return;

    if (box.length >= 10) {
      await box.deleteAt(0);
    }

    await box.add(query);
  }

  Future<void> _saveSearchResults(
      String query,
      List<MovieModel> movies,
      ) async {
    final box = HiveService.searchResultsBox;
    final encoded = movies.map((m) => jsonEncode(m.toJson())).toList();
    await box.put(query.toLowerCase(), jsonEncode(encoded));
  }

  List<MovieModel> getCachedResults(String query) {
    try {
      final box = HiveService.searchResultsBox;
      final raw = box.get(query.toLowerCase());
      if (raw == null) return [];
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => MovieModel.fromJson(jsonDecode(e))).toList();
    } catch (_) {
      return [];
    }
  }

  List<MovieModel> searchInFavorites(String query) {
    final favorites = HiveService.favoritesBox.values.toList();
    return favorites
        .where((m) => m.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<String> getSearchHistory() {
    return HiveService.searchHistoryBox.values.toList().reversed.toList();
  }

  Future<void> clearHistory() async {
    await HiveService.searchHistoryBox.clear();
  }

  Future<void> deleteHistoryItem(String query) async {
    final box = HiveService.searchHistoryBox;
    final index = box.values.toList().indexOf(query);
    if (index != -1) await box.deleteAt(index);
  }
}