import '../../../../core/storage/hive_service.dart';
import '../../../movies/data/models/movie_model.dart';

class FavoritesRepository {
  Future<void> addFavorite(MovieModel movie) async {
    final box = HiveService.favoritesBox;
    await box.put(movie.imdbId, movie);
  }

  Future<void> removeFavorite(String imdbId) async {
    final box = HiveService.favoritesBox;
    await box.delete(imdbId);
  }

  List<MovieModel> getFavorites() {
    return HiveService.favoritesBox.values.toList();
  }

  bool isFavorite(String imdbId) {
    return HiveService.favoritesBox.containsKey(imdbId);
  }
}