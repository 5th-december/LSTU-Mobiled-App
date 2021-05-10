import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';

part 'work_answer.g.dart';

@JsonSerializable()
class WorkAnswer {
  final num score;

  @JsonKey(name: 'answer_attachments')
  final WorkAnswerAttachment answerAttachments;

  WorkAnswer({this.score, this.answerAttachments});

  factory WorkAnswer.fromJson(Map<String, dynamic> json) =>
      _$WorkAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$WorkAnswerToJson(this);
}
