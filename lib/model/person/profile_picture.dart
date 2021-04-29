import 'dart:convert';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

part 'profile_picture.g.dart';

@JsonSerializable()
class ProfilePicture
{
  @JsonKey(name: 'person')
  final String person;

  @JsonKey(name: 'profile_picture')
  final String base64EncodedProfilePhoto;

  ProfilePicture({
    this.person,
    this.base64EncodedProfilePhoto
  });

  Uint8List toBinary() => base64Decode(this.base64EncodedProfilePhoto);

  factory ProfilePicture.fromJson(Map<String, dynamic> json) => _$ProfilePictureFromJson(json);
  Map<String, dynamic> toJson() => _$ProfilePictureToJson(this);
}