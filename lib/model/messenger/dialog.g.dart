// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dialog _$DialogFromJson(Map<String, dynamic> json) {
  return Dialog(
    id: json['id'] as String,
    companion: json['companion'] == null
        ? null
        : Person.fromJson(json['companion'] as Map<String, dynamic>),
    hasUnread: json['has_unread'] as bool,
    lastMessage: json['last_message'] == null
        ? null
        : PrivateMessage.fromJson(json['last_message'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DialogToJson(Dialog instance) => <String, dynamic>{
      'id': instance.id,
      'companion': instance.companion,
      'has_unread': instance.hasUnread,
      'last_message': instance.lastMessage,
    };
