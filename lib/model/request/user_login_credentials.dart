import 'package:json_annotation/json_annotation.dart';

part 'user_login_credentials.g.dart';

@JsonSerializable()
class UserLoginCredentials
{
  final String login;
  final String password;

  UserLoginCredentials({this.login, this.password});

  factory UserLoginCredentials.fromJson(Map<String, dynamic> json) => _$UserLoginCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$UserLoginCredentialsToJson(this);
}