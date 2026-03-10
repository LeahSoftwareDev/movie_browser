// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDetailsModelAdapter extends TypeAdapter<MovieDetailsModel> {
  @override
  final int typeId = 1;

  @override
  MovieDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDetailsModel(
      imdbId: fields[0] as String,
      title: fields[1] as String,
      year: fields[2] as String,
      poster: fields[3] as String,
      plot: fields[4] as String,
      director: fields[5] as String,
      actors: fields[6] as String,
      genre: fields[7] as String,
      runtime: fields[8] as String,
      imdbRating: fields[9] as String,
      language: fields[10] as String,
      type: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetailsModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.imdbId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.poster)
      ..writeByte(4)
      ..write(obj.plot)
      ..writeByte(5)
      ..write(obj.director)
      ..writeByte(6)
      ..write(obj.actors)
      ..writeByte(7)
      ..write(obj.genre)
      ..writeByte(8)
      ..write(obj.runtime)
      ..writeByte(9)
      ..write(obj.imdbRating)
      ..writeByte(10)
      ..write(obj.language)
      ..writeByte(11)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
