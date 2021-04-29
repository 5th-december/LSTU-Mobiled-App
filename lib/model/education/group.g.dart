// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    id: json['id'] as String,
    name: json['name'] as String,
    chair: json['chair'] == null
        ? null
        : Chair.fromJson(json['chair'] as Map<String, dynamic>),
    admission: json['admission'] == null
        ? null
        : DateTime.parse(json['admission'] as String),
    graduation: json['graduation'] == null
        ? null
        : DateTime.parse(json['graduation'] as String),
    speciality: json['speciality'] == null
        ? null
        : Speciality.fromJson(json['speciality'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chair': instance.chair,
      'admission': instance.admission?.toIso8601String(),
      'graduation': instance.graduation?.toIso8601String(),
      'speciality': instance.speciality,
    };
