import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';

part 'work_answer_attachment.g.dart';

@JsonSerializable()
class WorkAnswerAttachment {
  final String id;

  final String name;

  final List<Attachment> attachments;

  @JsonKey(name: 'ext_links')
  final List<ExternalLink> extLinks;

  WorkAnswerAttachment({this.id, this.name, this.attachments, this.extLinks});

  factory WorkAnswerAttachment.fromJson(Map<String, dynamic> json) =>
      _$WorkAnswerAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$WorkAnswerAttachmentToJson(this);
}
