import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/mbc_command.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/config/amqp_config.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class MbCPrivateMessageConsumerBloc
    extends AbstractBloc<NotificationConsumeState, NotificationConsumeEvent> {
  /*
   * Тип exchange
   */
  final _exchangeType = ExchangeType.TOPIC;

  /*
   *  Наименование exchange
   */
  String _exchangeName;

  final StreamController _messageController = StreamController();

  Consumer _amqpConsumer;

  @override
  dispose() {
    super.dispose();
    this._messageController.close();
    this._amqpConsumer.cancel();
  }

  /*
   * Состояние наличия уведомлений
   */
  Stream<NotificationConsumeState> get privateMessageConsumingStateStream =>
      this.stateContoller.stream.where(
          (event) => event is NotificationConsumeState<List<PrivateMessage>>);

  /*
   * Стрим событий подписки на уведомления
   */
  Stream<NotificationConsumeEvent>
      get _privateMessageStartConsumingEventStream =>
          this.eventController.stream.where((event) => event
              is StartNotificationConsumeEvent<MbCStartConsumeDialogMessages>);

  /*
   * Стрим событий подтверждения получения уведомлений
   */
  Stream<NotificationConsumeEvent> get _ackReceivedAllNotificationEventStream =>
      this
          .eventController
          .stream
          .where((event) => event is AckAllNotificationReceived);

  Stream<NotificationConsumeEvent>
      get _ackReceivedPartiallyNotificationEventStream =>
          this.eventController.stream.where((event) =>
              event is AckPartiallyNotificationReceived<PrivateMessage>);

  MbCPrivateMessageConsumerBloc(
      {@required AmqpService amqpService, @required AmqpConfig amqpConfig}) {
    this._exchangeName = amqpConfig.messageExchangeName;
    /**
     * Событие старта подписки на обновления
     */
    this._privateMessageStartConsumingEventStream.listen((event) async {
      final _event =
          event as StartNotificationConsumeEvent<MbCStartConsumeDialogMessages>;
      final command = _event.command;

      /*
       * AMQP ключ для сообщений - id диалога
       */
      final String routingKey = '${command.dialog.id}.${command.person.id}';

      final bindingData = AmqpBindingData(
          exchangeName: this._exchangeName,
          exchangeType: this._exchangeType,
          routingKeys: [routingKey]);

      try {
        this._amqpConsumer =
            await amqpService.startListenBindedQueue(bindingData);

        // При обработке потока сообщений подтягиваются также необработанные
        // уведолмения из бд, в состояние кладется результирующий список
        StreamTransformer privateMessageTransformer =
            StreamTransformer.fromHandlers(
                handleData: (data, EventSink sink) async {
          final privateMessage = PrivateMessage.fromJson(data);

          if (this.currentState
              is NotificationReadyState<List<PrivateMessage>>) {
            final List<PrivateMessage> existing = List<PrivateMessage>.from(
                (this.currentState
                        as NotificationReadyState<List<PrivateMessage>>)
                    .notifications);
            existing.add(privateMessage);
            sink.add(existing);
          } else {
            sink.add(<PrivateMessage>[privateMessage]);
          }
        });

        this
            ._messageController
            .stream
            .transform(privateMessageTransformer)
            .listen((event) {
          if (event is List) {
            this.updateState(NotificationReadyState<List<PrivateMessage>>(
                notifications: event.cast<PrivateMessage>()));
          }
        });

        this._amqpConsumer.listen((event) {
          this._messageController.sink.add(event.payloadAsJson);
        },
            onError: (e) => this
                .updateState(NotificationErrorState<List<Dialog>>(error: e)));

        this.updateState(NotificationReadyState<List<PrivateMessage>>(
            notifications: <PrivateMessage>[]));
      } on Exception catch (e) {
        this.updateState(
            NotificationErrorState<List<PrivateMessage>>(error: e));
      }
    });

    /**
     * Обработка события подтверждения получения уведомления
     */
    this._ackReceivedAllNotificationEventStream.listen((event) {
      if (this.currentState is NotificationReadyState<List<PrivateMessage>> &&
          (this.currentState as NotificationReadyState<List<PrivateMessage>>)
                  .notifications
                  .length !=
              0) {
        this.updateState(NotificationReadyState<List<PrivateMessage>>(
            notifications: <PrivateMessage>[]));
      }
    });

    this._ackReceivedPartiallyNotificationEventStream.listen((event) {
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
