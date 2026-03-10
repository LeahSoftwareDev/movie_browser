import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._(); // מונע יצירת instance

  // OMDb API
  static String get apiKey => dotenv.env['OMDB_API_KEY'] ?? '';
  static const String baseUrl = 'http://www.omdbapi.com/';

  // Hive Boxes
  static const String favoritesBox = 'favorites_box';
  static const String searchHistoryBox = 'search_history_box';
  static const String detailsCacheBox = 'details_cache_box';
  static const String searchResultsBox = 'search_results_box';


  // UI
  static const int searchHistoryLimit = 10;
}