// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationEntity _$EducationEntityFromJson(Map<String, dynamic> json) {
  return EducationEntity(
    id: json['id'] as String,
    status: json['status'] as String,
    start:
        json['start'] == null ? null : DateTime.parse(json['start'] as String),
    end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    name: json['name'] as String,
    form: json['form'] as String,
    qualification: json['qualification'] as String,
  );
}

Map<String, dynamic> _$EducationEntityToJson(EducationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'name': instance.name,
      'form': instance.form,
      'qualification': instance.qualification,
    };
