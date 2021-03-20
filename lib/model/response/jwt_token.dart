import 'package:json_annotation/json_annotation.dart';

part 'jwt_token.g.dart';

@JsonSerializable()
class JwtToken
{
  final String token;

  JwtToken({this.token});

  factory JwtToken.fromJson(Map<String, dynamic> json) => _$JwtTokenFromJson(json);
  Map<String, dynamic> toJson() => _$JwtTokenToJson(this);
}