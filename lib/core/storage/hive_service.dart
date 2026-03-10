import 'package:hive_flutter/hive_flutter.dart';
import '../../features/details/data/models/movie_details_model.dart';
import '../constants/app_constants.dart';
import '../../features/movies/data/models/movie_model.dart';

class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();
  }

  static void _registerAdapters() {
    Hive.registerAdapter(MovieModelAdapter());
    Hive.registerAdapter(MovieDetailsModelAdapter());

  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<MovieModel>(AppConstants.favoritesBox);
    await Hive.openBox<String>(AppConstants.searchHistoryBox);
    await Hive.openBox<MovieDetailsModel>(AppConstants.detailsCacheBox);
    await Hive.openBox<String>(AppConstants.searchResultsBox);
  }

  static Box<MovieModel> get favoritesBox =>
      Hive.box<MovieModel>(AppConstants.favoritesBox);

  static Box<String> get searchHistoryBox =>
      Hive.box<String>(AppConstants.searchHistoryBox);

  static Box<MovieDetailsModel> get detailsCacheBox =>
      Hive.box<MovieDetailsModel>(AppConstants.detailsCacheBox);

  static Box<String> get searchResultsBox =>
      Hive.box<String>(AppConstants.searchResultsBox);
}