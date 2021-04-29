// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    id: json['uoid'] as String,
    surname: json['lname'] as String,
    name: json['fname'] as String,
    partonymic: json['partonymic'] as String,
    birthday:
        json['bday'] == null ? null : DateTime.parse(json['bday'] as String),
    sex: json['sex'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    messenger: json['messenger'] as String,
    post: json['post'] as String,
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'uoid': instance.id,
      'lname': instance.surname,
      'fname': instance.name,
      'partonymic': instance.partonymic,
      'bday': instance.birthday?.toIso8601String(),
      'sex': instance.sex,
      'phone': instance.phone,
      'email': instance.email,
      'messenger': instance.messenger,
      'post': instance.post,
    };
