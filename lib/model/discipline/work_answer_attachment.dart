import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/validatable.dart';

part 'work_answer_attachment.g.dart';

@JsonSerializable()
class WorkAnswerAttachment implements Validatable {
  final String id;

  final String name;

  final List<Attachment> attachments;

  @JsonKey(name: 'ext_links')
  final List<ExternalLink> extLinks;

  WorkAnswerAttachment({this.id, this.name, this.attachments, this.extLinks});

  @override
  ValidationErrorBox validate() {
    return null;
  }

  factory WorkAnswerAttachment.fromJson(Map<String, dynamic> json) =>
      _$WorkAnswerAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$WorkAnswerAttachmentToJson(this);
}
