import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/person/person.dart';

part 'private_message.g.dart';

@JsonSerializable()
class PrivateMessage
{
  final String id;

  final String chat;

  final Person sender;

  @JsonKey(name: 'me_sender')
  final bool meSender;

  @JsonKey(name: 'message_text')
  final String messageText;

  @JsonKey(name: 'send_time')
  final DateTime sendTime;

  @JsonKey(name: 'is_read')
  final bool isRead;

  final List<ExternalLink> links;

  final List<Attachment> attachments;

  PrivateMessage({
    this.id, 
    this.chat, 
    this.sender, 
    this.meSender, 
    this.messageText, 
    this.sendTime, 
    this.isRead,
    this.links,
    this.attachments
  });

  factory PrivateMessage.fromJson(Map<String, dynamic> json) => _$PrivateMessageFromJson(json);
  Map<String, dynamic> toJson() => _$PrivateMessageToJson(this);
}