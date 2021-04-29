// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Achievement _$AchievementFromJson(Map<String, dynamic> json) {
  return Achievement(
    id: json['id'] as String,
    name: json['name'] as String,
    achievedDate: json['achieved_date'] == null
        ? null
        : DateTime.parse(json['achieved_date'] as String),
    kind: json['kind'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'achieved_date': instance.achievedDate?.toIso8601String(),
      'kind': instance.kind,
      'type': instance.type,
    };
