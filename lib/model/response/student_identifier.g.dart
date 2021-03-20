// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_identifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentIdentifier _$StudentIdentifierFromJson(Map<String, dynamic> json) {
  return StudentIdentifier(
    temporaryLoggingId: json['temporaryLoggingId'] as String,
    name: json['name'] as String,
    validUntil: json['validUntil'] as int,
  );
}

Map<String, dynamic> _$StudentIdentifierToJson(StudentIdentifier instance) =>
    <String, dynamic>{
      'temporaryLoggingId': instance.temporaryLoggingId,
      'name': instance.name,
      'validUntil': instance.validUntil,
    };
