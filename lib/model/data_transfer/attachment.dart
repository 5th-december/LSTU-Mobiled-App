import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

@JsonSerializable()
class Attachment {
  @JsonKey(name: 'attachment_name')
  final String attachmentName;

  @JsonKey(name: 'attachment_size')
  final String attachmentSize;

  @JsonKey(name: 'b64attachment')
  final String attachment;

  Attachment({this.attachmentName, this.attachmentSize, this.attachment});

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}
