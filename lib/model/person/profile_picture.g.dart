// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfilePicture _$ProfilePictureFromJson(Map<String, dynamic> json) {
  return ProfilePicture(
    person: json['person'] as String,
    base64EncodedProfilePhoto: json['profile_picture'] as String,
  );
}

Map<String, dynamic> _$ProfilePictureToJson(ProfilePicture instance) =>
    <String, dynamic>{
      'person': instance.person,
      'profile_picture': instance.base64EncodedProfilePhoto,
    };
