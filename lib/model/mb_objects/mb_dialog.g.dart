// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mb_dialog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MbDialog _$MbDialogFromJson(Map<String, dynamic> json) {
  return MbDialog(
    dialogId: json['dialog_id'] as String,
    lastMessageText: json['last_message_text'] as String,
    lastMessageId: json['last_message_id'] as String,
    unreadCount: json['unread_count'] as int,
    companionPatronymic: json['companion_patronymic'] as String,
    companionSurname: json['companion_surname'] as String,
    companionName: json['companion_name'] as String,
    companionId: json['companion_id'] as String,
    creatorId: json['creator_id'] as String,
    receiverId: json['receiver_id'] as String,
  );
}

Map<String, dynamic> _$MbDialogToJson(MbDialog instance) => <String, dynamic>{
      'creator_id': instance.creatorId,
      'receiver_id': instance.receiverId,
      'dialog_id': instance.dialogId,
      'companion_id': instance.companionId,
      'companion_name': instance.companionName,
      'companion_surname': instance.companionSurname,
      'companion_patronymic': instance.companionPatronymic,
      'unread_count': instance.unreadCount,
      'last_message_id': instance.lastMessageId,
      'last_message_text': instance.lastMessageText,
    };
