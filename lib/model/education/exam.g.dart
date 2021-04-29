// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exam _$ExamFromJson(Map<String, dynamic> json) {
  return Exam(
    discipline: json['discipline'] == null
        ? null
        : Discipline.fromJson(json['discipline'] as Map<String, dynamic>),
    teacherName: json['teacher_name'] as String,
    examTime: json['exam_time'] == null
        ? null
        : DateTime.parse(json['exam_time'] as String),
    room: json['room'] as String,
    campus: json['campus'] as String,
  );
}

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
      'discipline': instance.discipline,
      'teacher_name': instance.teacherName,
      'exam_time': instance.examTime?.toIso8601String(),
      'room': instance.room,
      'campus': instance.campus,
    };
