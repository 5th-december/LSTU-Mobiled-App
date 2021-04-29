// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timetable _$TimetableFromJson(Map<String, dynamic> json) {
  return Timetable(
    groupId: json['group_id'] as String,
    groupName: json['group_name'] as String,
    weeks: (json['weeks'] as List)
        ?.map((e) => e == null
            ? null
            : TimetableWeek.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TimetableToJson(Timetable instance) => <String, dynamic>{
      'group_id': instance.groupId,
      'group_name': instance.groupName,
      'weeks': instance.weeks,
    };
