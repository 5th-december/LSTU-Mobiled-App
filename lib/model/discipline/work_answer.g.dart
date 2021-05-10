// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkAnswer _$WorkAnswerFromJson(Map<String, dynamic> json) {
  return WorkAnswer(
    score: json['score'] as num,
    answerAttachments: json['answer_attachments'] == null
        ? null
        : WorkAnswerAttachment.fromJson(
            json['answer_attachments'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WorkAnswerToJson(WorkAnswer instance) =>
    <String, dynamic>{
      'score': instance.score,
      'answer_attachments': instance.answerAttachments,
    };
