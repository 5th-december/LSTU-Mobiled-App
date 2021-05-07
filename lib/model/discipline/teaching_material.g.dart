// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teaching_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeachingMaterial _$TeachingMaterialFromJson(Map<String, dynamic> json) {
  return TeachingMaterial(
    id: json['id'] as String,
    attachment: json['attachment'] == null
        ? null
        : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
    externalLink: json['external_link'] == null
        ? null
        : ExternalLink.fromJson(json['external_link'] as Map<String, dynamic>),
    materialName: json['material_name'] as String,
    materialType: json['material_type'] as String,
  );
}

Map<String, dynamic> _$TeachingMaterialToJson(TeachingMaterial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'material_name': instance.materialName,
      'material_type': instance.materialType,
      'attachment': instance.attachment,
      'external_link': instance.externalLink,
    };
