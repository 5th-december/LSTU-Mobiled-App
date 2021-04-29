// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_week.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableWeek _$TimetableWeekFromJson(Map<String, dynamic> json) {
  return TimetableWeek(
    current: json['current'] as bool,
    type: json['type'] as String,
    days: json['days'] == null
        ? null
        : TimetableDay.fromJson(json['days'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TimetableWeekToJson(TimetableWeek instance) =>
    <String, dynamic>{
      'current': instance.current,
      'type': instance.type,
      'days': instance.days,
    };
