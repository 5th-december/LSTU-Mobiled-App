import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';

part 'work_answer.g.dart';

@JsonSerializable()
class WorkAnswer {
  final num score;

  @JsonKey(name: 'answer_attachments')
  final List<WorkAnswerAttachment> answerAttachments;

  WorkAnswer({this.score, this.answerAttachments});

  factory WorkAnswer.fromJson(Map<String, dynamic> json) =>
      _$WorkAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$WorkAnswerToJson(this);
}
