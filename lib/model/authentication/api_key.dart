import 'package:json_annotation/json_annotation.dart';

part 'api_key.g.dart';

@JsonSerializable()
class ApiKey {
  final String token;

  final List<String> roles;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  ApiKey({this.token, this.refreshToken, this.roles});

  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);
  Map<String, dynamic> toJson() => _$ApiKeyToJson(this);
}
