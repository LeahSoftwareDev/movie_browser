// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Movie Browser';

  @override
  String get searchHint => 'Search movies...';

  @override
  String get searchButton => 'Search';

  @override
  String get clearAll => 'Clear All';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get searchPrompt => 'Search for a movie...';

  @override
  String noResultsFound(String query) {
    return 'No results found for \"$query\"';
  }

  @override
  String get tryDifferentTerm => 'Try a different search term';

  @override
  String resultsFor(String query) {
    return 'Results for \"$query\"';
  }

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get addFavoritesHint => 'Add movies by tapping the heart icon';

  @override
  String get viewDetails => 'View Details';

  @override
  String get director => 'Director';

  @override
  String get actors => 'Actors';

  @override
  String get plot => 'Plot';

  @override
  String get retry => 'Retry';

  @override
  String get offlineBanner => 'Offline – showing cached results';

  @override
  String get offlineDetailsBanner => 'Offline – showing last saved data';

  @override
  String get noInternetNoCacheError => 'No internet connection. No cached results found.';

  @override
  String get timeoutError => 'Connection timed out. Please try again.';

  @override
  String get invalidApiKeyError => 'Invalid API key. Please check your configuration.';

  @override
  String get generalError => 'Something went wrong. Please try again.';

  @override
  String get emptySearchError => 'Please enter a search term';

  @override
  String get goBack => 'Go Back';

  @override
  String get limitedDataAvailable => 'No internet connection – limited data available';

  @override
  String get searchIconLabel => 'Search icon';

  @override
  String get clearSearchLabel => 'Clear search';

  @override
  String get addToFavoritesLabel => 'Add to favorites';

  @override
  String get goToFavoritesLabel => 'Go to favorites';

  @override
  String get removeFromFavoritesLabel => 'Remove from favorites';

  @override
  String removeMovieFromFavorites(String title) {
    return 'Remove $title from favorites';
  }

  @override
  String searchHistoryItem(String query) {
    return 'Search history item: $query';
  }

  @override
  String movieCardLabel(String title, String year, String type) {
    return '$title, $year, $type';
  }
}
