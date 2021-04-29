// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teacher _$TeacherFromJson(Map<String, dynamic> json) {
  return Teacher(
    id: json['id'] as String,
    person: json['person'] == null
        ? null
        : Person.fromJson(json['person'] as Map<String, dynamic>),
    position: json['position'] as String,
  );
}

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
      'id': instance.id,
      'person': instance.person,
      'position': instance.position,
    };
