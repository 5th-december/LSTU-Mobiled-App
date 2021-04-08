// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SemesterEntity _$SemesterEntityFromJson(Map<String, dynamic> json) {
  return SemesterEntity(
    id: json['oid'] as String,
    year: json['year'] as String,
    season: json['season'] as String,
  );
}

Map<String, dynamic> _$SemesterEntityToJson(SemesterEntity instance) =>
    <String, dynamic>{
      'oid': instance.id,
      'year': instance.year,
      'season': instance.season,
    };
