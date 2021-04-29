// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contacts _$ContactsFromJson(Map<String, dynamic> json) {
  return Contacts(
    phone: json['phone'] as String,
    email: json['email'] as String,
    messenger: json['messenger'] as String,
  );
}

Map<String, dynamic> _$ContactsToJson(Contacts instance) => <String, dynamic>{
      'phone': instance.phone,
      'email': instance.email,
      'messenger': instance.messenger,
    };
