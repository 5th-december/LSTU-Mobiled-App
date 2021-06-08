// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscussionMessage _$DiscussionMessageFromJson(Map<String, dynamic> json) {
  return DiscussionMessage(
    id: json['id'] as String,
    sender: json['sender'] == null
        ? null
        : Person.fromJson(json['sender'] as Map<String, dynamic>),
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
    msg: json['msg'] as String,
    attachments: (json['attachments'] as List)
        ?.map((e) =>
            e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    externalLinks: (json['external_links'] as List)
        ?.map((e) =>
            e == null ? null : ExternalLink.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    discipline: json['discipline'] as String,
    semester: json['semester'] as String,
    group: json['group'] as String,
  );
}

Map<String, dynamic> _$DiscussionMessageToJson(DiscussionMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'discipline': instance.discipline,
      'semester': instance.semester,
      'sender': instance.sender,
      'created': instance.created?.toIso8601String(),
      'msg': instance.msg,
      'attachments': instance.attachments,
      'external_links': instance.externalLinks,
    };
