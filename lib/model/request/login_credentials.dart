import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'login_credentials.g.dart';

@JsonSerializable()
class LoginCredentials {
  @JsonKey(name: 'username')
  final String login;

  @JsonKey(name: 'password')
  final String password;

  LoginCredentials({this.login, this.password});

  factory LoginCredentials.fromJson(Map<String, dynamic> json) =>
      _$LoginCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$LoginCredentialsToJson(this);
}
