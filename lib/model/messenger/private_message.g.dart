// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateMessage _$PrivateMessageFromJson(Map<String, dynamic> json) {
  return PrivateMessage(
    id: json['id'] as String,
    chat: json['chat'] as String,
    sender: json['sender'] == null
        ? null
        : Person.fromJson(json['sender'] as Map<String, dynamic>),
    meSender: json['me_sender'] as bool,
    messageText: json['message_text'] as String,
    sendTime: json['send_time'] == null
        ? null
        : DateTime.parse(json['send_time'] as String),
    isRead: json['is_read'] as bool,
    links: (json['links'] as List)
        ?.map((e) =>
            e == null ? null : ExternalLink.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    attachments: (json['attachments'] as List)
        ?.map((e) =>
            e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PrivateMessageToJson(PrivateMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat': instance.chat,
      'sender': instance.sender,
      'me_sender': instance.meSender,
      'message_text': instance.messageText,
      'send_time': instance.sendTime?.toIso8601String(),
      'is_read': instance.isRead,
      'links': instance.links,
      'attachments': instance.attachments,
    };
