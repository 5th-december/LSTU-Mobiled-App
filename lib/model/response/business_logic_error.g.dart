// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_logic_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessLogicError _$BusinessLogicErrorFromJson(Map<String, dynamic> json) {
  return BusinessLogicError(
    code: json['code'] as String,
    systemMessage: json['systemMessage'] as String,
    userMessage: json['userMessage'] as String,
    errorProperties: (json['errorProperties'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$BusinessLogicErrorToJson(BusinessLogicError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'systemMessage': instance.systemMessage,
      'userMessage': instance.userMessage,
      'errorProperties': instance.errorProperties,
    };
