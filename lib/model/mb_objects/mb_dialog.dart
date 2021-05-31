import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';

part 'mb_dialog.g.dart';

@JsonSerializable()
class MbDialog {
  @JsonKey(name: "creator_id")
  final String creatorId;

  @JsonKey(name: "receiver_id")
  final String receiverId;

  @JsonKey(name: "dialog_id")
  final String dialogId;

  @JsonKey(name: "companion_id")
  final String companionId;

  @JsonKey(name: "companion_name")
  final String companionName;

  @JsonKey(name: "companion_surname")
  final String companionSurname;

  @JsonKey(name: "companion_patronymic")
  final String companionPatronymic;

  @JsonKey(name: "unread_count")
  final int unreadCount;

  @JsonKey(name: "last_message_id")
  final String lastMessageId;

  @JsonKey(name: "last_message_text")
  final String lastMessageText;

  MbDialog(
      {@required this.dialogId,
      this.lastMessageText,
      this.lastMessageId,
      this.unreadCount,
      this.companionPatronymic,
      this.companionSurname,
      this.companionName,
      this.companionId,
      this.creatorId,
      this.receiverId});

  factory MbDialog.fromJson(Map<String, dynamic> json) =>
      _$MbDialogFromJson(json);
  Map<String, dynamic> toJson() => _$MbDialogToJson(this);

  Dialog getDialog() {
    final dialog = Dialog(
        id: this.dialogId,
        companion: Person(
            id: this.companionId,
            name: this.companionName,
            surname: this.companionSurname,
            patronymic: this.companionPatronymic),
        hasUnread: this.unreadCount != 0,
        lastMessage: PrivateMessage(
          id: this.lastMessageId,
          chat: this.dialogId,
          messageText: this.lastMessageText,
        ));
    return dialog;
  }
}
