// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return Attachment(
    mimeType: json['mime_type'] as String,
    attachmentName: json['attachment_name'] as String,
    attachmentSize: (json['attachment_size'] as num)?.toDouble(),
    attachment: json['attachment'] as String,
  );
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'mime_type': instance.mimeType,
      'attachment_name': instance.attachmentName,
      'attachment_size': instance.attachmentSize,
      'attachment': instance.attachment,
    };
