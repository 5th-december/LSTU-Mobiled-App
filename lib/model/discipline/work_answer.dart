import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';

part 'work_answer.g.dart';

@JsonSerializable()
class WorkAnswer
{
  final num score;

  final List<Attachment> attachments;

  @JsonKey(name: 'ext_links')
  final List<ExternalLink> extLinks;

  WorkAnswer({this.score, this.attachments, this.extLinks});

  factory WorkAnswer.fromJson(Map<String, dynamic> json) => _$WorkAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$WorkAnswerToJson(this);
}