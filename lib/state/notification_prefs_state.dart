import 'package:flutter/foundation.dart';
import 'package:lk_client/model/util/notification_preferences.dart';

abstract class NotificationPrefsState {}

class NotificationPrefsInitState extends NotificationPrefsState {}

class NotificationPrefsLoadingState extends NotificationPrefsState {}

class NotificationPrefsErrorState extends NotificationPrefsState {
  final Exception error;
  final NotificationPrefsState previous;
  NotificationPrefsErrorState({@required this.error, this.previous});
}

class NotificationPrefsReadyState extends NotificationPrefsState {
  final NotificationPreferences preferences;
  NotificationPrefsReadyState({@required this.preferences});
}
