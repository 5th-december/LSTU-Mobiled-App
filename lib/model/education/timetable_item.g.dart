// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableItem _$TimetableItemFromJson(Map<String, dynamic> json) {
  return TimetableItem(
    discipline: json['discipline'] == null
        ? null
        : Discipline.fromJson(json['discipline'] as Map<String, dynamic>),
    teacher: json['teacher'] == null
        ? null
        : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
    lessonType: json['lesson_type'] as String,
    lessonNumber: json['lesson_number'] as int,
    beginTime: json['begin_time'] as String,
    endTime: json['end_time'] as String,
    room: json['room'] as String,
    campus: json['campus'] as String,
  );
}

Map<String, dynamic> _$TimetableItemToJson(TimetableItem instance) =>
    <String, dynamic>{
      'discipline': instance.discipline,
      'teacher': instance.teacher,
      'lesson_type': instance.lessonType,
      'lesson_number': instance.lessonNumber,
      'begin_time': instance.beginTime,
      'end_time': instance.endTime,
      'room': instance.room,
      'campus': instance.campus,
    };
