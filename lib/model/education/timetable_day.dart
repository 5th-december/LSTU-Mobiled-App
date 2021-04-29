import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/education/timetable_item.dart';

part 'timetable_day.g.dart';

@JsonSerializable()
class TimetableDay
{
  final String id;

  final String name;

  final int number;

  final List<TimetableItem> lessons;

  TimetableDay({this.id, this.name, this.number, this.lessons});

  factory TimetableDay.fromJson(Map<String, dynamic> json) => _$TimetableDayFromJson(json);
  Map<String, dynamic> toJson() => _$TimetableDayToJson(this);
}