import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/person/person.dart';

part 'mb_discussion_message.g.dart';

@JsonSerializable()
class MbDiscussionMessage {
  final String id;

  final String group;

  final String discipline;

  final String semester;

  @JsonKey(name: 'author_id')
  final String authorId;

  @JsonKey(name: 'author_name')
  final String authorName;

  @JsonKey(name: 'author_surname')
  final String authorSurname;

  @JsonKey(name: 'author_patronymic')
  final String authorPatronymic;

  @JsonKey(name: 'text_content')
  final String textContent;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'doc_name')
  final String docName;

  @JsonKey(name: 'doc_size')
  final String docSize;

  @JsonKey(name: 'link_text')
  final String linkText;

  @JsonKey(name: 'link_content')
  final String linkContent;

  MbDiscussionMessage(
      {this.linkContent,
      this.linkText,
      this.docSize,
      this.docName,
      this.textContent,
      this.createdAt,
      this.authorPatronymic,
      this.authorSurname,
      this.authorName,
      this.authorId,
      this.id,
      this.discipline,
      this.group,
      this.semester});

  factory MbDiscussionMessage.fromJson(Map<String, dynamic> json) =>
      _$MbDiscussionMessageFromJson(json);
  Map<String, dynamic> toJson() => _$MbDiscussionMessageToJson(this);

  DiscussionMessage getDiscussionMessage() {
    Attachment attachment;
    if (this.docName != null || this.docSize != null) {
      attachment = Attachment(
          attachmentName: this.docName, attachmentSize: this.docSize);
    }

    ExternalLink externalLink;
    if (this.linkText != null || this.linkContent != null) {
      externalLink =
          ExternalLink(linkContent: this.linkContent, linkText: this.linkText);
    }

    final sender = Person(
        id: this.authorId,
        name: this.authorName,
        surname: this.authorSurname,
        patronymic: this.authorPatronymic);

    return DiscussionMessage(
        id: this.id,
        sender: sender,
        created: this.createdAt,
        msg: this.textContent,
        attachments: attachment != null ? [attachment] : null,
        externalLinks: externalLink != null ? [externalLink] : null);
  }
}
