import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/validatable.dart';

part 'discussion_message.g.dart';

@JsonSerializable()
class DiscussionMessage implements Validatable {
  final String id;

  final String group;

  final String discipline;

  final String semester;

  final Person sender;

  final DateTime created;

  final String msg;

  final List<Attachment> attachments;

  @JsonKey(name: 'external_links')
  final List<ExternalLink> externalLinks;

  @override
  ValidationErrorBox validate() {
    List<ValidationError> errors = [];
    if (null == this.msg || '' == this.msg) {
      errors.add(ValidationError(
          path: 'messageText', message: 'Нельзя отправить пустое сообщение'));
    }

    if (2048 < this.msg.length) {
      errors.add(ValidationError(
          path: 'messageText',
          message:
              'Длина сообщения превышает максимально допустимую 2048 символов'));
    }

    return ValidationErrorBox(errors);
  }

  DiscussionMessage(
      {this.id,
      this.sender,
      this.created,
      this.msg,
      this.attachments,
      this.externalLinks,
      this.discipline,
      this.semester,
      this.group});

  static DiscussionMessage fromJson(Map<String, dynamic> json) =>
      _$DiscussionMessageFromJson(json);
  Map<String, dynamic> toJson() => _$DiscussionMessageToJson(this);
}
