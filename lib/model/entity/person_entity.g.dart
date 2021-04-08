// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonEntity _$PersonEntityFromJson(Map<String, dynamic> json) {
  return PersonEntity(
    id: json['uoid'] as String,
    surname: json['lname'] as String,
    name: json['fname'] as String,
    partonymic: json['partonymic'] as String,
    birthday: _dateFromJson(json['bday'] as String),
    sex: json['sex'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    messenger: json['messenger'] as String,
  );
}

Map<String, dynamic> _$PersonEntityToJson(PersonEntity instance) =>
    <String, dynamic>{
      'uoid': instance.id,
      'lname': instance.surname,
      'fname': instance.name,
      'partonymic': instance.partonymic,
      'bday': _dateToJson(instance.birthday),
      'sex': instance.sex,
      'phone': instance.phone,
      'email': instance.email,
      'messenger': instance.messenger,
    };
