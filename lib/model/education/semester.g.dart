// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Semester _$SemesterFromJson(Map<String, dynamic> json) {
  return Semester(
    id: json['id'] as String,
    year: json['year'] as String,
    season: json['season'] as String,
  );
}

Map<String, dynamic> _$SemesterToJson(Semester instance) => <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'season': instance.season,
    };
