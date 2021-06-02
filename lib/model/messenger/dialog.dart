import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';

part 'dialog.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Dialog {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Person companion;

  @JsonKey(name: 'has_unread')
  @HiveField(2)
  final bool hasUnread;

  @JsonKey(name: 'last_message')
  @HiveField(3)
  final PrivateMessage lastMessage;

  Dialog({this.id, this.companion, this.hasUnread, this.lastMessage});

  static Dialog fromJson(Map<String, dynamic> json) => _$DialogFromJson(json);
  Map<String, dynamic> toJson() => _$DialogToJson(this);
}
