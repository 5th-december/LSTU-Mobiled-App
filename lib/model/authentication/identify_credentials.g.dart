// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identify_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentifyCredentials _$IdentifyCredentialsFromJson(Map<String, dynamic> json) {
  return IdentifyCredentials(
    username: json['username'] as String,
    enterYear: json['enter_year'] as int,
    zBookNumber: json['z_book_number'] as String,
  );
}

Map<String, dynamic> _$IdentifyCredentialsToJson(
        IdentifyCredentials instance) =>
    <String, dynamic>{
      'username': instance.username,
      'enter_year': instance.enterYear,
      'z_book_number': instance.zBookNumber,
    };
