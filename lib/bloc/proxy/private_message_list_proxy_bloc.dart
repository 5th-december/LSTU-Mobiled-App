import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/private_message_list_bloc.dart';
import 'package:lk_client/bloc/message_broker_consumers/mbc_chat_update_consumer_bloc.dart';
import 'package:lk_client/bloc/message_broker_consumers/mbc_private_message_consumer_bloc.dart';
import 'package:lk_client/bloc_container/mbc_chat_update_bloc_container.dart';
import 'package:lk_client/bloc_container/mbc_private_message_bloc_container.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/event/proxy_event.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class StartNotifyPrivateMessagesOnDialog {
  Dialog trackedDialog;
  Person trackedPerson;
  StartNotifyPrivateMessagesOnDialog(
      {@required this.trackedDialog, @required this.trackedPerson});
}

class PrivateMessageListProxyBloc extends AbstractBloc<dynamic, dynamic> {
  final PrivateMessageListBloc listBloc;

  final MbCPrivateMessageConsumerBloc privateMessageConsumerBloc;

  final MbCChatUpdateConsumerBloc messagesChangeConsumerBloc;

  StreamSubscription messageListUpdatesSubscription,
      messageChangeUpdatesSubscription;

  @override
  dispose() {
    messageChangeUpdatesSubscription.cancel();
    messageListUpdatesSubscription.cancel();
    super.dispose();
  }

  Stream<dynamic> get privateMessageListStateStream =>
      this.stateContoller.stream;

  Stream<dynamic> get _privateMessageListInitEventStream =>
      this.eventController.stream.where((event) =>
          event is ProxyInitEvent<StartNotifyPrivateMessagesOnDialog>);

  Stream<dynamic> get _privateMessageListLoadingEventStream =>
      this.eventController.stream.where((event) =>
          event is LoadChunkEvent<LoadPrivateChatMessagesListCommand>);

  static Future<PrivateMessageListProxyBloc> init(
      {@required
          Future<MbCPrivateMessageBlocContainer> mbCPrivateMessageBlocContainer,
      @required
          Future<MbCChatUpdateBlocContainer> mbCChatUpdateBlocContainer,
      @required
          PrivateMessageListBloc privateMessageListBloc,
      @required
          Person person,
      @required
          Dialog dialog}) async {
    MbCPrivateMessageBlocContainer _mbCPrivateMessageBlocContainer =
        await mbCPrivateMessageBlocContainer;
    MbCChatUpdateBlocContainer _mbCChatUpdateBlocContainer =
        await mbCChatUpdateBlocContainer;
    MbCChatUpdateConsumerBloc mbCChatUpdateConsumerBloc =
        await _mbCChatUpdateBlocContainer.getBloc(dialog, person);
    MbCPrivateMessageConsumerBloc mbCPrivateMessageConsumerBloc =
        await _mbCPrivateMessageBlocContainer.getBloc(dialog, person);
    return PrivateMessageListProxyBloc(
        listBloc: privateMessageListBloc,
        privateMessageConsumerBloc: mbCPrivateMessageConsumerBloc,
        messagesChangeConsumerBloc: mbCChatUpdateConsumerBloc);
  }

  PrivateMessageListProxyBloc(
      {@required this.listBloc,
      @required this.privateMessageConsumerBloc,
      @required this.messagesChangeConsumerBloc}) {
    this._privateMessageListInitEventStream.listen((event) {
      /**
       * Listener на событие добавления сообщений
       */
      this.messageListUpdatesSubscription = this
          .privateMessageConsumerBloc
          .privateMessageConsumingStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<PrivateMessage>> &&
            event.notifications.length != 0) {
          this.listBloc.eventController.sink.add(
              ExternalDataAddEvent<PrivateMessage>(
                  externalAddedData: event.notifications));

          this
              .privateMessageConsumerBloc
              .eventController
              .sink
              .add(AckAllNotificationReceived());
        }
      });

      /*
       * Listener на события обновления чата 
       */
      this.messageChangeUpdatesSubscription = this
          .messagesChangeConsumerBloc
          .dialogReadNotificationStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<PrivateMessage>> &&
            event.notifications.length != 0) {
          this.listBloc.eventController.sink.add(
              ExternalDataUpdateEvent<PrivateMessage>(
                  externalUpdatedData: event.notifications));

          this
              .messagesChangeConsumerBloc
              .eventController
              .sink
              .add(AckAllNotificationReceived());
        }
      });

      this
          .listBloc
          .eventController
          .add(EndlessScrollingInitEvent<PrivateMessage>());

      this.listBloc.endlessListScrollingStateStream.listen((event) {
        this.updateState(event);
      });
    });

    this._privateMessageListLoadingEventStream.listen((event) {
      this.listBloc.eventController.sink.add(event);
    });
  }
}
