import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';

part 'mb_private_message.g.dart';

@JsonSerializable()
class MbPrivateMessage {
  @JsonKey(name: "message_id")
  final String messageId;

  @JsonKey(name: "sender_companion")
  final String senderCompanion;

  @JsonKey(name: "dialog_id")
  final String dialogId;

  @JsonKey(name: "text_content")
  final String textContent;

  @JsonKey(name: "author_id")
  final String authorId;

  @JsonKey(name: "author_name")
  final String authorName;

  @JsonKey(name: "author_surname")
  final String authorSurname;

  @JsonKey(name: "author_patronymic")
  final String authorPatronymic;

  @JsonKey(name: "created_at")
  final DateTime createdAt;

  @JsonKey(name: "doc_name")
  final String docName;

  @JsonKey(name: "doc_size")
  final double docSize;

  @JsonKey(name: "link_text")
  final String linkText;

  @JsonKey(name: "link_content")
  final String linkContent;

  @JsonKey(name: "message_number")
  final String messageNumber;

  factory MbPrivateMessage.fromJson(Map<String, dynamic> json) =>
      _$MbPrivateMessageFromJson(json);
  Map<String, dynamic> toJson() => _$MbPrivateMessageToJson(this);

  PrivateMessage getPrivateMessage() {
    final attachments = <Attachment>[];

    if (this.docSize != null && this.docName != null) {
      Attachment attachment = Attachment(
          attachmentName: this.docName,
          attachmentSize: this.docSize.toStringAsFixed(2));
      attachments.add(attachment);
    }

    final externalLinks = <ExternalLink>[];

    if (this.linkText != null && this.linkContent != null) {
      ExternalLink link =
          ExternalLink(linkContent: this.linkContent, linkText: this.linkText);
      externalLinks.add(link);
    }

    final message = PrivateMessage(
        id: this.messageId,
        chat: this.dialogId,
        messageText: this.textContent,
        sender: Person(
            id: this.authorId,
            name: this.authorName,
            surname: this.authorSurname,
            patronymic: this.authorPatronymic),
        meSender: this.senderCompanion == this.authorId,
        sendTime: this.createdAt,
        isRead: false,
        attachments: attachments,
        links: externalLinks);

    return message;
  }

  MbPrivateMessage(
      {@required this.authorId,
      @required this.authorName,
      @required this.authorPatronymic,
      @required this.authorSurname,
      @required this.createdAt,
      @required this.dialogId,
      @required this.docName,
      @required this.docSize,
      @required this.linkContent,
      @required this.linkText,
      @required this.messageId,
      @required this.messageNumber,
      @required this.senderCompanion,
      @required this.textContent});
}
