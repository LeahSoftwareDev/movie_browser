import 'package:hive/hive.dart';

part 'movie_details_model.g.dart';

@HiveType(typeId: 1)
class MovieDetailsModel {
  @HiveField(0)
  final String imdbId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String year;

  @HiveField(3)
  final String poster;

  @HiveField(4)
  final String plot;

  @HiveField(5)
  final String director;

  @HiveField(6)
  final String actors;

  @HiveField(7)
  final String genre;

  @HiveField(8)
  final String runtime;

  @HiveField(9)
  final String imdbRating;

  @HiveField(10)
  final String language;

  @HiveField(11)
  final String type;

  const MovieDetailsModel({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
    required this.plot,
    required this.director,
    required this.actors,
    required this.genre,
    required this.runtime,
    required this.imdbRating,
    required this.language,
    required this.type,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      imdbId: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      poster: json['Poster'] ?? '',
      plot: json['Plot'] ?? '',
      director: json['Director'] ?? '',
      actors: json['Actors'] ?? '',
      genre: json['Genre'] ?? '',
      runtime: json['Runtime'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
      language: json['Language'] ?? '',
      type: json['Type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbId,
      'Title': title,
      'Year': year,
      'Poster': poster,
      'Plot': plot,
      'Director': director,
      'Actors': actors,
      'Genre': genre,
      'Runtime': runtime,
      'imdbRating': imdbRating,
      'Language': language,
      'Type': type,
    };
  }
}