// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_work.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentWork _$StudentWorkFromJson(Map<String, dynamic> json) {
  return StudentWork(
    id: json['id'] as String,
    teacher: json['teacher'] == null
        ? null
        : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
    workType: json['work_type'] as String,
    workName: json['work_name'] as String,
    workTheme: json['work_theme'] as String,
    workMaxScore: json['work_max_score'] as num,
    answer: json['answer'] == null
        ? null
        : WorkAnswer.fromJson(json['answer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StudentWorkToJson(StudentWork instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacher': instance.teacher,
      'work_type': instance.workType,
      'work_name': instance.workName,
      'work_theme': instance.workTheme,
      'work_max_score': instance.workMaxScore,
      'answer': instance.answer,
    };
