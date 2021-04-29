// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableDay _$TimetableDayFromJson(Map<String, dynamic> json) {
  return TimetableDay(
    id: json['id'] as String,
    name: json['name'] as String,
    number: json['number'] as int,
    lessons: (json['lessons'] as List)
        ?.map((e) => e == null
            ? null
            : TimetableItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TimetableDayToJson(TimetableDay instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
      'lessons': instance.lessons,
    };
