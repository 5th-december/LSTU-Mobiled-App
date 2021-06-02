// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DialogAdapter extends TypeAdapter<Dialog> {
  @override
  final int typeId = 1;

  @override
  Dialog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dialog(
      id: fields[0] as String,
      companion: fields[1] as Person,
      hasUnread: fields[2] as bool,
      lastMessage: fields[3] as PrivateMessage,
    );
  }

  @override
  void write(BinaryWriter writer, Dialog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companion)
      ..writeByte(2)
      ..write(obj.hasUnread)
      ..writeByte(3)
      ..write(obj.lastMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DialogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
