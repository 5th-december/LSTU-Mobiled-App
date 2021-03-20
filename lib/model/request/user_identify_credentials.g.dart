// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_identify_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIdentifyCredentials _$UserIdentifyCredentialsFromJson(
    Map<String, dynamic> json) {
  return UserIdentifyCredentials(
    name: json['name'] as String,
    enterYear: json['enterYear'] as int,
    zNumber: json['zNumber'] as String,
  );
}

Map<String, dynamic> _$UserIdentifyCredentialsToJson(
        UserIdentifyCredentials instance) =>
    <String, dynamic>{
      'name': instance.name,
      'enterYear': instance.enterYear,
      'zNumber': instance.zNumber,
    };
