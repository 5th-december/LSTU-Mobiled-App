// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_register_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegisterCredentials _$UserRegisterCredentialsFromJson(
    Map<String, dynamic> json) {
  return UserRegisterCredentials(
    temporaryLoggingId: json['temporaryLoggingId'] as String,
    login: json['login'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$UserRegisterCredentialsToJson(
        UserRegisterCredentials instance) =>
    <String, dynamic>{
      'temporaryLoggingId': instance.temporaryLoggingId,
      'login': instance.login,
      'password': instance.password,
    };
