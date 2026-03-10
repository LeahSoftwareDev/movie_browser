import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Movie Browser'**
  String get appTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search movies...'**
  String get searchHint;

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Search for a movie...'**
  String get searchPrompt;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found for \"{query}\"'**
  String noResultsFound(String query);

  /// No description provided for @tryDifferentTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentTerm;

  /// No description provided for @resultsFor.
  ///
  /// In en, this message translates to:
  /// **'Results for \"{query}\"'**
  String resultsFor(String query);

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @addFavoritesHint.
  ///
  /// In en, this message translates to:
  /// **'Add movies by tapping the heart icon'**
  String get addFavoritesHint;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @director.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get director;

  /// No description provided for @actors.
  ///
  /// In en, this message translates to:
  /// **'Actors'**
  String get actors;

  /// No description provided for @plot.
  ///
  /// In en, this message translates to:
  /// **'Plot'**
  String get plot;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline – showing cached results'**
  String get offlineBanner;

  /// No description provided for @offlineDetailsBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline – showing last saved data'**
  String get offlineDetailsBanner;

  /// No description provided for @noInternetNoCacheError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. No cached results found.'**
  String get noInternetNoCacheError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please try again.'**
  String get timeoutError;

  /// No description provided for @invalidApiKeyError.
  ///
  /// In en, this message translates to:
  /// **'Invalid API key. Please check your configuration.'**
  String get invalidApiKeyError;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get generalError;

  /// No description provided for @emptySearchError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a search term'**
  String get emptySearchError;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @limitedDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No internet connection – limited data available'**
  String get limitedDataAvailable;

  /// No description provided for @searchIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Search icon'**
  String get searchIconLabel;

  /// No description provided for @clearSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearchLabel;

  /// No description provided for @addToFavoritesLabel.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavoritesLabel;

  /// No description provided for @goToFavoritesLabel.
  ///
  /// In en, this message translates to:
  /// **'Go to favorites'**
  String get goToFavoritesLabel;

  /// No description provided for @removeFromFavoritesLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavoritesLabel;

  /// No description provided for @removeMovieFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove {title} from favorites'**
  String removeMovieFromFavorites(String title);

  /// No description provided for @searchHistoryItem.
  ///
  /// In en, this message translates to:
  /// **'Search history item: {query}'**
  String searchHistoryItem(String query);

  /// No description provided for @movieCardLabel.
  ///
  /// In en, this message translates to:
  /// **'{title}, {year}, {type}'**
  String movieCardLabel(String title, String year, String type);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
