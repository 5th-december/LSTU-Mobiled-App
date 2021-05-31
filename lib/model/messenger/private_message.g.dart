// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrivateMessageAdapter extends TypeAdapter<PrivateMessage> {
  @override
  final int typeId = 0;

  @override
  PrivateMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrivateMessage(
      id: fields[0] as String,
      chat: fields[1] as String,
      sender: fields[2] as Person,
      meSender: fields[3] as bool,
      messageText: fields[4] as String,
      sendTime: fields[5] as DateTime,
      isRead: fields[6] as bool,
      links: (fields[7] as List)?.cast<ExternalLink>(),
      attachments: (fields[8] as List)?.cast<Attachment>(),
    );
  }

  @override
  void write(BinaryWriter writer, PrivateMessage obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chat)
      ..writeByte(2)
      ..write(obj.sender)
      ..writeByte(3)
      ..write(obj.meSender)
      ..writeByte(4)
      ..write(obj.messageText)
      ..writeByte(5)
      ..write(obj.sendTime)
      ..writeByte(6)
      ..write(obj.isRead)
      ..writeByte(7)
      ..write(obj.links)
      ..writeByte(8)
      ..write(obj.attachments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrivateMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
