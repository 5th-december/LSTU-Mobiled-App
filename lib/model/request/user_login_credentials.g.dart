// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginCredentials _$UserLoginCredentialsFromJson(Map<String, dynamic> json) {
  return UserLoginCredentials(
    login: json['login'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$UserLoginCredentialsToJson(
        UserLoginCredentials instance) =>
    <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
    };
