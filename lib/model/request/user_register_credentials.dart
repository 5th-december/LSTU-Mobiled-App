import 'package:json_annotation/json_annotation.dart';

part 'user_register_credentials.g.dart';

@JsonSerializable()
class UserRegisterCredentials
{
  final String temporaryLoggingId;
  final String login;
  final String password;

  UserRegisterCredentials({this.temporaryLoggingId, this.login, this.password});

  factory UserRegisterCredentials.fromJson(Map<String, dynamic> json) => _$UserRegisterCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$UserRegisterCredentialsToJson(this);
}