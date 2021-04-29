import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/discipline/discipline.dart';

part 'exam.g.dart';

@JsonSerializable()
class Exam
{
  final Discipline discipline;

  @JsonKey(name: 'teacher_name')
  final String teacherName;

  @JsonKey(name: 'exam_time')
  final DateTime examTime;

  final String room;

  final String campus;

  Exam({this.discipline, this.teacherName, this.examTime, this.room, this.campus});

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
  Map<String, dynamic> toJson() => _$ExamToJson(this);
}