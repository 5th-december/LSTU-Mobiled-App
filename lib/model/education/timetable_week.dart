import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/education/timetable_day.dart';

part 'timetable_week.g.dart';

@JsonSerializable()
class TimetableWeek
{
  final bool current;

  final String type;

  final TimetableDay days;

  TimetableWeek({this.current, this.type, this.days});

  factory TimetableWeek.fromJson(Map<String, dynamic> json) => _$TimetableWeekFromJson(json);
  Map<String, dynamic> toJson() => _$TimetableWeekToJson(this);
}