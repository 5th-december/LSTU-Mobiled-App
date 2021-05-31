import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/validatable.dart';

part 'private_message.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class PrivateMessage extends Validatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String chat;

  @HiveField(2)
  final Person sender;

  @JsonKey(name: 'me_sender')
  @HiveField(3)
  final bool meSender;

  @JsonKey(name: 'message_text')
  @HiveField(4)
  final String messageText;

  @JsonKey(name: 'send_time')
  @HiveField(5)
  final DateTime sendTime;

  @JsonKey(name: 'is_read')
  @HiveField(6)
  final bool isRead;

  @HiveField(7)
  final List<ExternalLink> links;

  @HiveField(8)
  final List<Attachment> attachments;

  @override
  ValidationErrorBox validate() {
    List<ValidationError> errors = [];
    if (null == this.messageText || '' == this.messageText) {
      errors.add(ValidationError(
          path: 'messageText', message: 'Нельзя отправить пустое сообщение'));
    }

    if (2048 < this.messageText.length) {
      errors.add(ValidationError(
          path: 'messageText',
          message:
              'Длина сообщения превышает максимально допустимую 2048 символов'));
    }

    return ValidationErrorBox(errors);
  }

  PrivateMessage(
      {this.id,
      this.chat,
      this.sender,
      this.meSender,
      this.messageText,
      this.sendTime,
      this.isRead,
      this.links,
      this.attachments});

  static PrivateMessage fromJson(Map<String, dynamic> json) =>
      _$PrivateMessageFromJson(json);
  Map<String, dynamic> toJson() => _$PrivateMessageToJson(this);
}
