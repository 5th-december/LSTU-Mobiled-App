import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/notification_prefs_event.dart';
import 'package:lk_client/model/util/notification_preferences.dart';
import 'package:lk_client/service/api_consumer/util_query_service.dart';
import 'package:lk_client/state/notification_prefs_state.dart';

class NotificationPrefsBloc
    extends AbstractBloc<NotificationPrefsState, NotificationPrefsEvent> {
  final UtilQueryService utilQueryService;

  Stream<NotificationPrefsState> get notificationPrefsStateStream =>
      this.stateContoller.stream;

  Stream<NotificationPrefsEvent> get _loadPrefsEventStream => this
      .eventController
      .stream
      .where((event) => event is LoadNotificationPrefsEvent);

  Stream<NotificationPrefsEvent> get _changePrefsEventStream => this
      .eventController
      .stream
      .where((event) => !(event is LoadNotificationPrefsEvent));

  NotificationPrefsBloc({@required this.utilQueryService}) {
    this.updateState(NotificationPrefsInitState());

    this._loadPrefsEventStream.listen((event) async {
      final previousState = this.currentState;

      this.updateState(NotificationPrefsLoadingState());

      try {
        NotificationPreferences preferences =
            await this.utilQueryService.getCurrentNotificationPreferences();

        this.updateState(NotificationPrefsReadyState(preferences: preferences));
      } on Exception catch (e) {
        this.updateState(
            NotificationPrefsErrorState(error: e, previous: previousState));
      }
    });

    this._changePrefsEventStream.listen((event) async {
      NotificationPreferences requestedPrefs;

      if (event is EnableDiscussionMessagesNotificationEvent) {
        requestedPrefs =
            NotificationPreferences(discussionMsgNotificationsDisabled: false);
      } else if (event is EnablePrivateMessagesNotificationEvent) {
        requestedPrefs =
            NotificationPreferences(privateMsgNotificationsDisabled: false);
      } else if (event is DisableDiscussionMessagesNotificationEvent) {
        requestedPrefs =
            NotificationPreferences(discussionMsgNotificationsDisabled: true);
      } else if (event is DisablePrivateMessagesNotificationEvent) {
        requestedPrefs =
            NotificationPreferences(privateMsgNotificationsDisabled: true);
      } else {
        return;
      }

      final previousState = this.currentState;

      if (previousState is NotificationPrefsLoadingState) return;

      try {
        NotificationPreferences updated = await this
            .utilQueryService
            .changeNotificationPreferences(requestedPrefs);

        this.updateState(NotificationPrefsReadyState(preferences: updated));
      } on Exception catch (e) {
        this.updateState(
            NotificationPrefsErrorState(error: e, previous: previousState));
      }
    });
  }
}
