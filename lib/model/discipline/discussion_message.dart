import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/person/person.dart';

part 'discussion_message.g.dart';

@JsonSerializable()
class DiscussionMessage
{
  final String id;

  final Person sender;

  final DateTime created;

  final String msg;

  final List<Attachment> attachments;

  @JsonKey(name: 'external_links')
  final List<ExternalLink> externalLinks;

  DiscussionMessage({this.id, this.sender, this.created, this.msg, this.attachments, this.externalLinks});

  static DiscussionMessage fromJson(Map<String, dynamic> json) => _$DiscussionMessageFromJson(json);
  Map<String, dynamic> toJson() => _$DiscussionMessageToJson(this);
}