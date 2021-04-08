// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EducationEntity _$EducationEntityFromJson(Map<String, dynamic> json) {
  return EducationEntity(
    id: json['id'] as String,
    status: json['status'] as String,
    start: _dateFromJson(json['start'] as String),
    end: _dateFromJson(json['end'] as String),
    name: json['name'] as String,
    form: json['form'] as String,
    qualification: json['qualification'] as String,
  );
}

Map<String, dynamic> _$EducationEntityToJson(EducationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'start': _dateToJson(instance.start),
      'end': _dateToJson(instance.end),
      'name': instance.name,
      'form': instance.form,
      'qualification': instance.qualification,
    };
