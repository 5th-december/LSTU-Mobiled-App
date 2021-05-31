// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPreferences _$NotificationPreferencesFromJson(
    Map<String, dynamic> json) {
  return NotificationPreferences(
    discussionMsgNotificationsDisabled:
        json['disable_discussion_message_notifications'] as bool,
    privateMsgNotificationsDisabled:
        json['disable_private_message_notifications'] as bool,
  );
}

Map<String, dynamic> _$NotificationPreferencesToJson(
        NotificationPreferences instance) =>
    <String, dynamic>{
      'disable_private_message_notifications':
          instance.privateMsgNotificationsDisabled,
      'disable_discussion_message_notifications':
          instance.discussionMsgNotificationsDisabled,
    };
