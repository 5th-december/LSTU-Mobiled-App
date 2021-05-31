import 'package:flutter/foundation.dart';

abstract class NotificationConsumeState<T> {}

class NotificationReadyState<T> extends NotificationConsumeState<T> {
  T notifications;
  NotificationReadyState({@required this.notifications});
}

class NotificationErrorState<T> extends NotificationConsumeState<T> {
  Exception error;
  NotificationErrorState({@required this.error});
}
