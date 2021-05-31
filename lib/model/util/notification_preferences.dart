import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_preferences.g.dart';

@JsonSerializable()
class NotificationPreferences {
  @JsonKey(name: 'disable_private_message_notifications')
  final bool privateMsgNotificationsDisabled;

  @JsonKey(name: "disable_discussion_message_notifications")
  final bool discussionMsgNotificationsDisabled;

  NotificationPreferences(
      {this.discussionMsgNotificationsDisabled,
      this.privateMsgNotificationsDisabled});

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferencesToJson(this);
}
