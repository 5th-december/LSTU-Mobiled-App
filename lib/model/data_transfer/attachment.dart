import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

@JsonSerializable()
class Attachment {
  @JsonKey(name: 'mime_type')
  final String mimeType;

  @JsonKey(name: 'attachment_name')
  final String attachmentName;

  @JsonKey(name: 'attachment_size')
  final double attachmentSize;

  final String attachment;

  Attachment(
      {this.mimeType,
      this.attachmentName,
      this.attachmentSize,
      this.attachment});

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}
