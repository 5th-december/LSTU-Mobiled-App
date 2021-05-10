// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return Attachment(
    attachmentName: json['attachment_name'] as String,
    attachmentSize: json['attachment_size'] as String,
    attachment: json['b64attachment'] as String,
  );
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'attachment_name': instance.attachmentName,
      'attachment_size': instance.attachmentSize,
      'b64attachment': instance.attachment,
    };
