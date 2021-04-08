// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) {
  return ApiKey(
    token: json['token'] as String,
    refreshToken: json['refresh_token'] as String,
    roles: (json['roles'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ApiKeyToJson(ApiKey instance) => <String, dynamic>{
      'token': instance.token,
      'roles': instance.roles,
      'refresh_token': instance.refreshToken,
    };
