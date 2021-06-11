import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/mbc_command.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/config/amqp_config.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class MbCChatUpdateConsumerBloc
    extends AbstractBloc<NotificationConsumeState, NotificationConsumeEvent> {
  final _exchangeType = ExchangeType.TOPIC;

  String _exchangeName;

  final StreamController _dialogReadController = StreamController();

  Consumer _messageBrokerConsumer;

  @override
  dispose() {
    super.dispose();
    this._dialogReadController.close();
    this._messageBrokerConsumer.cancel();
  }

  /*
   * Стрим состояний уведомлений
   */
  Stream<NotificationConsumeState> get dialogReadNotificationStateStream =>
      this.stateContoller.stream.where(
          (event) => event is NotificationConsumeState<List<PrivateMessage>>);

  /*
   * Стрим событий подписки на уведомлений
   */
  Stream<NotificationConsumeEvent> get _dialogReadStartConsumingEventStream =>
      this.eventController.stream.where((event) =>
          event is StartNotificationConsumeEvent<MbCStartConsumeDialogUpdates>);

  /*
   * Стрим событий подтверждения получения уведомлений
   */
  Stream<NotificationConsumeEvent>
      get _ackDialogReadAllNotificationReceivedEventStream => this
          .eventController
          .where((event) => event is AckAllNotificationReceived);

  Stream<NotificationConsumeEvent>
      get _ackDialogReadPartiallyNotificationReceivedEventStream =>
          this.eventController.where((event) =>
              event is AckPartiallyNotificationReceived<List<PrivateMessage>>);

  MbCChatUpdateConsumerBloc(
      {@required AmqpService amqpService, @required AmqpConfig amqpConfig}) {
    this._exchangeName = amqpConfig.privateMessageUpdateExchangeName;

    /**
     * События подписки на обновления
     */
    this._dialogReadStartConsumingEventStream.listen((event) async {
      final _event =
          event as StartNotificationConsumeEvent<MbCStartConsumeDialogUpdates>;

      final command = _event.command;

      final String routingKey =
          "${command.watchedDialog.id}.${command.person.id}";

      final bindingData = AmqpBindingData(
          exchangeName: this._exchangeName,
          exchangeType: this._exchangeType,
          routingKeys: [routingKey]);

      try {
        this._messageBrokerConsumer =
            await amqpService.startConsumePrivateQueue(bindingData);

        final dialogReadStreamTransformer =
            StreamTransformer.fromHandlers(handleData: (data, EventSink sink) {
          final updatedMessage = PrivateMessage.fromJson(data);

          if (this.currentState
              is NotificationReadyState<List<PrivateMessage>>) {
            final existing = List<PrivateMessage>.from((this.currentState
                    as NotificationReadyState<List<PrivateMessage>>)
                .notifications);
            existing.add(updatedMessage);
            sink.add(existing);
          } else {
            sink.add(<PrivateMessage>[updatedMessage]);
          }
        });

        this
            ._dialogReadController
            .stream
            .transform(dialogReadStreamTransformer)
            .listen((event) {
          if (event is List) {
            this.updateState(NotificationReadyState<List<PrivateMessage>>(
                notifications: event.cast<PrivateMessage>()));
          }
        });

        this._messageBrokerConsumer.listen((event) {
          this._dialogReadController.sink.add(event.payloadAsJson);
        },
            onError: (e) => this.updateState(
                NotificationErrorState<List<PrivateMessage>>(error: e)));

        this.updateState(NotificationReadyState<List<PrivateMessage>>(
            notifications: <PrivateMessage>[]));
      } on Exception catch (e) {
        this.updateState(
            NotificationErrorState<List<PrivateMessage>>(error: e));
      }
    });

    /**
     * Подписчик событий подтверждения получения всех событий
     */
    this._ackDialogReadAllNotificationReceivedEventStream.listen((event) {
      if (this.currentState is NotificationReadyState<List<PrivateMessage>> &&
          (this.currentState as NotificationReadyState<List<PrivateMessage>>)
                  .notifications
                  .length !=
              0) {
        this.updateState(NotificationReadyState<List<PrivateMessage>>(
            notifications: <PrivateMessage>[]));
      }
    });

    this._ackDialogReadPartiallyNotificationReceivedEventStream.listen((event) {
      if (this.currentState is NotificationReadyState<List<PrivateMessage>> &&
          (this.currentState as NotificationReadyState<List<PrivateMessage>>)
                  .notifications
                  .length !=
              0) {
        final currentNotifications =
            (this.currentState as NotificationReadyState<List<PrivateMessage>>)
                .notifications;
        final consumedNotifications =
            (event as AckPartiallyNotificationReceived<PrivateMessage>)
                .deliveredNotifications;
        currentNotifications.removeWhere((PrivateMessage element) =>
            consumedNotifications.firstWhere(
                (PrivateMessage consumed) => consumed.id == element.id,
                orElse: () => null) !=
            null);
        this.updateState(NotificationReadyState<List<PrivateMessage>>(
            notifications: currentNotifications));
      }
    });
  }
}
