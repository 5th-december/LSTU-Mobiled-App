// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkAnswer _$WorkAnswerFromJson(Map<String, dynamic> json) {
  return WorkAnswer(
    score: json['score'] as num,
    attachments: (json['attachments'] as List)
        ?.map((e) =>
            e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    extLinks: (json['ext_links'] as List)
        ?.map((e) =>
            e == null ? null : ExternalLink.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$WorkAnswerToJson(WorkAnswer instance) =>
    <String, dynamic>{
      'score': instance.score,
      'attachments': instance.attachments,
      'ext_links': instance.extLinks,
    };
