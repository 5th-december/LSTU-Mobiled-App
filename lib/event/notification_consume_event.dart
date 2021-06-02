import 'package:flutter/foundation.dart';

abstract class NotificationConsumeEvent {}

class StartNotificationConsumeEvent<T> extends NotificationConsumeEvent {
  T command;
  StartNotificationConsumeEvent({@required this.command});
}

class AckNotificationReceived extends NotificationConsumeEvent {}

class AckAllNotificationReceived extends AckNotificationReceived {}

class AckPartiallyNotificationReceived<T> extends AckNotificationReceived {
  List<T> deliveredNotifications;
  AckPartiallyNotificationReceived({@required this.deliveredNotifications});
}
