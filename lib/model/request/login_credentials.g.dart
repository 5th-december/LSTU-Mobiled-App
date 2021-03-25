// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginCredentials _$LoginCredentialsFromJson(Map<String, dynamic> json) {
  return LoginCredentials(
    login: json['login'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$LoginCredentialsToJson(LoginCredentials instance) =>
    <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
    };
