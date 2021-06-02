// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mb_discussion_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MbDiscussionMessage _$MbDiscussionMessageFromJson(Map<String, dynamic> json) {
  return MbDiscussionMessage(
    linkContent: json['link_content'] as String,
    linkText: json['link_text'] as String,
    docSize: json['doc_size'] as String,
    docName: json['doc_name'] as String,
    textContent: json['text_content'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    authorPatronymic: json['author_patronymic'] as String,
    authorSurname: json['author_surname'] as String,
    authorName: json['author_name'] as String,
    authorId: json['author_id'] as String,
    id: json['id'] as String,
    discipline: json['discipline'] as String,
    group: json['group'] as String,
    semester: json['semester'] as String,
  );
}

Map<String, dynamic> _$MbDiscussionMessageToJson(
        MbDiscussionMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'discipline': instance.discipline,
      'semester': instance.semester,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'author_surname': instance.authorSurname,
      'author_patronymic': instance.authorPatronymic,
      'text_content': instance.textContent,
      'created_at': instance.createdAt?.toIso8601String(),
      'doc_name': instance.docName,
      'doc_size': instance.docSize,
      'link_text': instance.linkText,
      'link_content': instance.linkContent,
    };
