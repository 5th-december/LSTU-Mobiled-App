// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faculty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Faculty _$FacultyFromJson(Map<String, dynamic> json) {
  return Faculty(
    id: json['id'] as String,
    facCode: json['fac_code'] as String,
    facName: json['fac_name'] as String,
  );
}

Map<String, dynamic> _$FacultyToJson(Faculty instance) => <String, dynamic>{
      'id': instance.id,
      'fac_code': instance.facCode,
      'fac_name': instance.facName,
    };
