import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/person/person.dart';

part 'teacher.g.dart';

@JsonSerializable()
class Teacher
{
  final String id;

  final Person person;

  final String position;

  Teacher({this.id, this.person, this.position});

  factory Teacher.fromJson(Map<String, dynamic> json) => _$TeacherFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherToJson(this);
}