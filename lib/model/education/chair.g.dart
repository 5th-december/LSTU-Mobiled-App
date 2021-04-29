// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chair _$ChairFromJson(Map<String, dynamic> json) {
  return Chair(
    id: json['id'] as String,
    chairName: json['chair_name'] as String,
    chairNameAbbr: json['chair_name_abbr'] as String,
    faculty: json['faculty'] == null
        ? null
        : Faculty.fromJson(json['faculty'] as Map<String, dynamic>),
    person: json['person'] == null
        ? null
        : Person.fromJson(json['person'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChairToJson(Chair instance) => <String, dynamic>{
      'id': instance.id,
      'chair_name': instance.chairName,
      'chair_name_abbr': instance.chairNameAbbr,
      'faculty': instance.faculty,
      'person': instance.person,
    };
