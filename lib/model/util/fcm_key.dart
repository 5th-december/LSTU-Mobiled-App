import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fcm_key.g.dart';

@JsonSerializable()
class FcmKey {
  @JsonKey(name: "fcm_key")
  final String fcmKey;

  FcmKey({@required this.fcmKey});

  factory FcmKey.fromJson(Map<String, dynamic> json) => _$FcmKeyFromJson(json);
  Map<String, dynamic> toJson() => _$FcmKeyToJson(this);
}
