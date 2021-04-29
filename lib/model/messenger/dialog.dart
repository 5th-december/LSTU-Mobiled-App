import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';

part 'dialog.g.dart';

@JsonSerializable()
class Dialog
{
  final String id;

  final Person companion;

  @JsonKey(name: 'has_unread')
  final bool hasUnread;

  @JsonKey(name: 'last_message')
  final PrivateMessage lastMessage;

  Dialog({this.id, this.companion, this.hasUnread, this.lastMessage});

  factory Dialog.fromJson(Map<String, dynamic> json) => _$DialogFromJson(json);
  Map<String, dynamic> toJson() => _$DialogToJson(this);
}