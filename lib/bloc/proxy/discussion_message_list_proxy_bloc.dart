import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/discussion_list_bloc.dart';
import 'package:lk_client/bloc/message_broker_consumers/mbc_discussion_message_consumer_bloc.dart';
import 'package:lk_client/bloc/message_broker_consumers/mbc_discussion_update_consumer_bloc.dart';
import 'package:lk_client/bloc_container/mbc_discussion_message_bloc_container.dart';
import 'package:lk_client/bloc_container/mbc_discussion_update_bloc_container.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/event/proxy_event.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class StartNotifyOnDiscussion {
  final String semester;
  final String discipline;
  final String group;
  StartNotifyOnDiscussion(
      {@required this.semester,
      @required this.group,
      @required this.discipline});
}

class DiscussionMessageListProxyBloc extends AbstractBloc<dynamic, dynamic> {
  final DiscussionListBloc listBloc;

  final MbCDiscussionMessageConsumerBloc mbcDiscussionListConsumerBloc;

  final MbCDiscussionUpdateConsumerBloc mbCDiscussionUpdateConsumerBloc;

  Stream<dynamic> get discussionMessageListStateStream =>
      this.stateContoller.stream;

  Stream<dynamic> get _discussionMessageListInitEventStream => this
      .eventController
      .stream
      .where((event) => event is ProxyInitEvent<StartNotifyOnDiscussion>);

  Stream<dynamic> get _discussionMessageLoadEventStream =>
      this.eventController.stream.where((event) =>
          event is LoadChunkEvent<LoadDisciplineDiscussionListCommand>);

  static Future<DiscussionMessageListProxyBloc> init(
      {@required
          DiscussionListBloc discussionListBloc,
      @required
          Future<MbCDiscussionUpdateBlocContainer>
              mbCDiscussionUpdateBlocContainer,
      @required
          Future<MbCDiscussionMessageBlocContainer>
              mbCDiscussionMessageBlocContainer}) async {
    MbCDiscussionMessageBlocContainer _mbCDiscussionMessageBlocContainer =
        await mbCDiscussionMessageBlocContainer;
    MbCDiscussionMessageConsumerBloc mbCDiscussionMessageConsumerBloc =
        _mbCDiscussionMessageBlocContainer.getBloc();
    MbCDiscussionUpdateBlocContainer _mbCDiscussionUpdateBlocContainer =
        await mbCDiscussionUpdateBlocContainer;
    MbCDiscussionUpdateConsumerBloc mbCDiscussionUpdateConsumerBloc =
        _mbCDiscussionUpdateBlocContainer.getBloc();
    return DiscussionMessageListProxyBloc(
        listBloc: discussionListBloc,
        mbcDiscussionListConsumerBloc: mbCDiscussionMessageConsumerBloc,
        mbCDiscussionUpdateConsumerBloc: mbCDiscussionUpdateConsumerBloc);
  }

  DiscussionMessageListProxyBloc(
      {@required this.listBloc,
      @required this.mbcDiscussionListConsumerBloc,
      @required this.mbCDiscussionUpdateConsumerBloc}) {
    /**
     * Обработчик события инициализации
     */
    this._discussionMessageListInitEventStream.listen((event) {
      final _event = event as ProxyInitEvent<StartNotifyOnDiscussion>;

      final command = _event.command;
      /**
       * Подписка на обновления состяний блока событий
       */
      mbcDiscussionListConsumerBloc.discussionMessageConsumingStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<DiscussionMessage>> &&
            event.notifications.length != 0) {
          /**
           * Выборка сообщений только для указанного чата
           */
          final selectedNotificationsForCurrentChat = event.notifications
              .where((DiscussionMessage element) =>
                  element.discipline == command.discipline &&
                  element.group == element.group &&
                  element.semester == element.semester)
              .toList();

          if (selectedNotificationsForCurrentChat.length == 0) {
            return;
          }

          this.listBloc.eventController.sink.add(
              ExternalDataAddEvent<DiscussionMessage>(
                  externalAddedData: selectedNotificationsForCurrentChat));

          /**
           * Частичное подтверждение получения
           */
          this.mbcDiscussionListConsumerBloc.eventController.sink.add(
              AckPartiallyNotificationReceived<DiscussionMessage>(
                  deliveredNotifications: selectedNotificationsForCurrentChat));
        }
      });

      mbCDiscussionUpdateConsumerBloc.discissionUpdateNotificationStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<DiscussionMessage>> &&
            event.notifications.length != 0) {
          final selectedNotificationsForCurrentChat = event.notifications
              .where((DiscussionMessage element) =>
                  element.discipline == command.discipline &&
                  element.group == element.group &&
                  element.semester == element.semester)
              .toList();

          if (selectedNotificationsForCurrentChat.length == 0) {
            return;
          }

          this.listBloc.eventController.sink.add(
              ExternalDataUpdateEvent<DiscussionMessage>(
                  externalUpdatedData: selectedNotificationsForCurrentChat));

          /**
           * Частичное подтверждение получения
           */
          this.mbCDiscussionUpdateConsumerBloc.eventController.sink.add(
              AckPartiallyNotificationReceived<DiscussionMessage>(
                  deliveredNotifications: selectedNotificationsForCurrentChat));
        }
      });

      this
          .listBloc
          .eventController
          .add(EndlessScrollingInitEvent<DiscussionMessage>());

      this.listBloc.endlessListScrollingStateStream.listen((event) {
        this.updateState(event);
      });
    });

    this._discussionMessageLoadEventStream.listen((event) {
      this.listBloc.eventController.sink.add(event);
    });
  }
}
