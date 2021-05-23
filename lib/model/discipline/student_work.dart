import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/discipline/work_answer.dart';
import 'package:lk_client/model/education/teacher.dart';

part 'student_work.g.dart';

@JsonSerializable()
class StudentWork {
  final String id;

  final Teacher teacher;

  @JsonKey(name: 'work_type')
  final String workType;

  @JsonKey(name: 'work_name')
  final String workName;

  @JsonKey(name: 'work_theme')
  final String workTheme;

  @JsonKey(name: 'work_max_score')
  final num workMaxScore;

  final WorkAnswer answer;

  StudentWork(
      {this.id,
      this.teacher,
      this.workType,
      this.workName,
      this.workTheme,
      this.workMaxScore,
      this.answer});

  static StudentWork fromJson(Map<String, dynamic> json) =>
      _$StudentWorkFromJson(json);
  Map<String, dynamic> toJson() => _$StudentWorkToJson(this);
}
