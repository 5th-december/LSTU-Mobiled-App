// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectEntity _$SubjectEntityFromJson(Map<String, dynamic> json) {
  return SubjectEntity(
    subjectId: json['subject_id'] as String,
    subjectName: json['subject_name'] as String,
    chairName: json['chair_name'] as String,
  );
}

Map<String, dynamic> _$SubjectEntityToJson(SubjectEntity instance) =>
    <String, dynamic>{
      'subject_id': instance.subjectId,
      'subject_name': instance.subjectName,
      'chair_name': instance.chairName,
    };
