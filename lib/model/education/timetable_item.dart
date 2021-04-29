import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/teacher.dart';

part 'timetable_item.g.dart';

@JsonSerializable()
class TimetableItem
{
  final Discipline discipline;

  final Teacher teacher;

  @JsonKey(name: 'lesson_type')
  final String lessonType;

  @JsonKey(name: 'lesson_number')
  final int lessonNumber;

  @JsonKey(name: 'begin_time')
  final String beginTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  final String room;

  final String campus;

  TimetableItem ({
    this.discipline, 
    this.teacher, 
    this.lessonType, 
    this.lessonNumber, 
    this.beginTime,
    this.endTime,
    this.room,
    this.campus
  });

  static TimetableItem fromJson(Map<String, dynamic> json) => _$TimetableItemFromJson(json);
  Map<String, dynamic> toJson() => _$TimetableItemToJson(this);
}