// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Education _$EducationFromJson(Map<String, dynamic> json) {
  return Education(
    id: json['id'] as String,
    status: json['status'] as String,
    group: json['group'] == null
        ? null
        : Group.fromJson(json['group'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EducationToJson(Education instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'group': instance.group,
    };
