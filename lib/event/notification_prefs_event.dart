abstract class NotificationPrefsEvent {}

class LoadNotificationPrefsEvent extends NotificationPrefsEvent {}

class DisablePrivateMessagesNotificationEvent extends NotificationPrefsEvent {}

class EnablePrivateMessagesNotificationEvent extends NotificationPrefsEvent {}

class DisableDiscussionMessagesNotificationEvent
    extends NotificationPrefsEvent {}

class EnableDiscussionMessagesNotificationEvent extends NotificationPrefsEvent {
}
