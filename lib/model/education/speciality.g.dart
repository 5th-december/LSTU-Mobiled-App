// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speciality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Speciality _$SpecialityFromJson(Map<String, dynamic> json) {
  return Speciality(
    id: json['id'] as String,
    specName: json['spec_name'] as String,
    specNameAbbr: json['spec_name_abbr'] as String,
    qualification: json['qualification'] as String,
    form: json['form'] as String,
  );
}

Map<String, dynamic> _$SpecialityToJson(Speciality instance) =>
    <String, dynamic>{
      'id': instance.id,
      'spec_name': instance.specName,
      'spec_name_abbr': instance.specNameAbbr,
      'qualification': instance.qualification,
      'form': instance.form,
    };
