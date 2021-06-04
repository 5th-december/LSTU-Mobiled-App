import 'package:flutter/foundation.dart';

abstract class NotificationConsumeEvent {}

class StartNotificationConsumeEvent<C> extends NotificationConsumeEvent {
  C command;
  StartNotificationConsumeEvent({@required this.command});
}

abstract class AckNotificationReceived extends NotificationConsumeEvent {}

class AckAllNotificationReceived extends AckNotificationReceived {}

class AckPartiallyNotificationReceived<T> extends AckNotificationReceived {
  List<T> deliveredNotifications;
  AckPartiallyNotificationReceived({@required this.deliveredNotifications});
}
