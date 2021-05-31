// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mb_private_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MbPrivateMessage _$MbPrivateMessageFromJson(Map<String, dynamic> json) {
  return MbPrivateMessage(
    authorId: json['author_id'] as String,
    authorName: json['author_name'] as String,
    authorPatronymic: json['author_patronymic'] as String,
    authorSurname: json['author_surname'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    dialogId: json['dialog_id'] as String,
    docName: json['doc_name'] as String,
    docSize: (json['doc_size'] as num)?.toDouble(),
    linkContent: json['link_content'] as String,
    linkText: json['link_text'] as String,
    messageId: json['message_id'] as String,
    messageNumber: json['message_number'] as String,
    senderCompanion: json['sender_companion'] as String,
    textContent: json['text_content'] as String,
  );
}

Map<String, dynamic> _$MbPrivateMessageToJson(MbPrivateMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'sender_companion': instance.senderCompanion,
      'dialog_id': instance.dialogId,
      'text_content': instance.textContent,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'author_surname': instance.authorSurname,
      'author_patronymic': instance.authorPatronymic,
      'created_at': instance.createdAt?.toIso8601String(),
      'doc_name': instance.docName,
      'doc_size': instance.docSize,
      'link_text': instance.linkText,
      'link_content': instance.linkContent,
      'message_number': instance.messageNumber,
    };
