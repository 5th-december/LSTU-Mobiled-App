// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalData _$PersonalDataFromJson(Map<String, dynamic> json) {
  return PersonalData(
    phone: json['phone'] as String,
    email: json['email'] as String,
    messenger: json['messenger'] as String,
  );
}

Map<String, dynamic> _$PersonalDataToJson(PersonalData instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'email': instance.email,
      'messenger': instance.messenger,
    };
