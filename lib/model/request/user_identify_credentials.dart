import 'package:json_annotation/json_annotation.dart';

part 'user_identify_credentials.g.dart';

@JsonSerializable()
class UserIdentifyCredentials
{
  final String name;
  final int enterYear;
  final String zNumber;

  UserIdentifyCredentials({this.name, this.enterYear, this.zNumber});

  factory UserIdentifyCredentials.fromJson(Map<String, dynamic> json) => _$UserIdentifyCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$UserIdentifyCredentialsToJson(this);
}