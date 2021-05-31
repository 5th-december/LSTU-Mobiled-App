import 'package:flutter/foundation.dart';

abstract class NotificationConsumeEvent {}

class StartNotificationConsumeEvent<T> extends NotificationConsumeEvent {
  T command;
  StartNotificationConsumeEvent({@required this.command});
}

class AckNotificationReceived<T> extends NotificationConsumeEvent {
  T receivedNotification;
  AckNotificationReceived({@required this.receivedNotification});
}
