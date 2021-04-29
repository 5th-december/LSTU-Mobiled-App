import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/education/timetable_week.dart';

part 'timetable.g.dart';

@JsonSerializable()
class Timetable
{
  @JsonKey(name: 'group_id')
  final String groupId;

  @JsonKey(name: 'group_name')
  final String groupName;

  final List<TimetableWeek> weeks;

  Timetable({this.groupId, this.groupName, this.weeks});

  factory Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);
  Map<String, dynamic> toJson() => _$TimetableToJson(this);
}