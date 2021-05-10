// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_answer_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkAnswerAttachment _$WorkAnswerAttachmentFromJson(Map<String, dynamic> json) {
  return WorkAnswerAttachment(
    id: json['id'] as String,
    name: json['name'] as String,
    attachments: (json['attachments'] as List)
        ?.map((e) =>
            e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    extLinks: (json['ext_links'] as List)
        ?.map((e) =>
            e == null ? null : ExternalLink.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$WorkAnswerAttachmentToJson(
        WorkAnswerAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'attachments': instance.attachments,
      'ext_links': instance.extLinks,
    };
