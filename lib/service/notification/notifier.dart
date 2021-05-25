import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lk_client/service/notification/notification_select_handler.dart';

class Notifier {
  final NotificationSelectHandler handler;
  FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  NotificationDetails get _highPriorityNotification => NotificationDetails(
      android: AndroidNotificationDetails(
          'channelId', 'channelName', 'channelDescription',
          priority: Priority.high, importance: Importance.high),
      iOS: IOSNotificationDetails());

  Notifier({@required this.handler}) {
    this._localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOs = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOs);
    this._localNotificationsPlugin.initialize(initSettings,
        onSelectNotification: this._onNotificationTap);
  }

  Future<void> showNotification(int notificationId, String notificationTitle,
      String notificationBody, Map<String, dynamic> payloadData) async {
    final encodedPayloadData = jsonEncode(payloadData);
    await this._localNotificationsPlugin.show(notificationId, notificationTitle,
        notificationBody, this._highPriorityNotification,
        payload: encodedPayloadData);
  }

  Future<void> cancelNotification(int notificationId) async {
    await this._localNotificationsPlugin.cancel(notificationId);
  }

  Future<void> _onNotificationTap(String payload) async {
    Map<String, dynamic> notificationDataJson = jsonDecode(payload);
    this.handler.handleApply(notificationDataJson);
  }
}
