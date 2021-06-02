import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/amqp_consumers/amqp_private_message_consumer_bloc.dart';
import 'package:lk_client/bloc/amqp_consumers/mbc_dialog_read_consumer_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/private_message_list_bloc.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/event/notification_consume_event.dart';
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

  final AmqpPrivateMessageConsumerBloc amqpPrivateMessageConsumerBloc;

  final MbCDialogReadConsumerBloc amqpMessagesReadConsumerBloc;

  Stream<dynamic> get privateMessageListStateStream =>
      this.stateContoller.stream;

  Stream<dynamic> get _privateMessageListInitEventStream =>
      this.eventController.stream.where((event) => event
          is EndlessScrollingLoadEvent<StartNotifyPrivateMessagesOnDialog>);

  Stream<dynamic> get _privateMessageListLoadingEventStream =>
      this.eventController.stream.where(
          (event) => event is EndlessScrollingLoadEvent<List<PrivateMessage>>);

  PrivateMessageListProxyBloc(
      {@required this.listBloc,
      @required this.amqpPrivateMessageConsumerBloc,
      @required this.amqpMessagesReadConsumerBloc}) {
    this._privateMessageListInitEventStream.listen((event) {
      final _event = event
          as EndlessScrollingLoadEvent<StartNotifyPrivateMessagesOnDialog>;

      /**
       * Подписка на события добавлений сообщений
       */
      this.amqpPrivateMessageConsumerBloc.eventController.sink.add(
          StartNotificationConsumeEvent<AmqpStartConsumeDialogMessages>(
              command: AmqpStartConsumeDialogMessages(
                  dialog: _event.command.trackedDialog)));

      /**
       * Listener на событие добавления сообщений
       */
      this
          .amqpPrivateMessageConsumerBloc
          .privateMessageConsumingStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<PrivateMessage>> &&
            event.notifications.length != 0) {
          this.listBloc.eventController.sink.add(
              ExternalDataAddEvent<PrivateMessage>(
                  externalAddedData: event.notifications));

          this
              .amqpPrivateMessageConsumerBloc
              .eventController
              .sink
              .add(AckAllNotificationReceived());
        }
      });

      /**
       * Подписка на события обновлений чата
       */
      this.amqpMessagesReadConsumerBloc.eventController.sink.add(
          StartNotificationConsumeEvent<MbCStartConsumeDialogUpdates>(
              command: MbCStartConsumeDialogUpdates(
                  readerCompanion: _event.command.trackedPerson,
                  watchedDialog: _event.command.trackedDialog)));
      /*
       * Listener на события обновления чата 
       */
      this
          .amqpMessagesReadConsumerBloc
          .dialogReadNotificationStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<PrivateMessage>> &&
            event.notifications.length != 0) {
          this.listBloc.eventController.sink.add(
              ExternalDataUpdateEvent<PrivateMessage>(
                  externalUpdatedData: event.notifications));

          this
              .amqpMessagesReadConsumerBloc
              .eventController
              .sink
              .add(AckAllNotificationReceived());

          /**
           * Добавление события в блок чтения сообщений
           */
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
      final _event = event as EndlessScrollingLoadEvent;
      this.listBloc.eventController.sink.add(_event);
    });
  }
}
