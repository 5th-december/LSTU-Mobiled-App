import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/mb_objects/mb_private_message.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/config/amqp_config.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class AmqpStartConsumeDialogMessages {
  final Dialog dialog;
  AmqpStartConsumeDialogMessages({@required this.dialog});
}

class AmqpPrivateMessageConsumerBloc
    extends AbstractBloc<NotificationConsumeState, NotificationConsumeEvent> {
  /*
   * Тип exchange
   */
  final _exchangeType = ExchangeType.DIRECT;

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
              is StartNotificationConsumeEvent<AmqpStartConsumeDialogMessages>);

  /*
   * Стрим событий подтверждения получения уведомлений
   *
  Stream<NotificationConsumeEvent> get _ackNotificationReceivedEventStream =>
      this.eventController.stream.where(
          (event) => event is AckNotificationReceived<List<PrivateMessage>>);*/

  AmqpPrivateMessageConsumerBloc(
      {@required AmqpService amqpService, @required AmqpConfig amqpConfig}) {
    this._exchangeName = amqpConfig.messageExchangeName;
    /**
     * Событие старта подписки на обновления
     */
    this._privateMessageStartConsumingEventStream.listen((event) async {
      final _event = event
          as StartNotificationConsumeEvent<AmqpStartConsumeDialogMessages>;
      final command = _event.command;

      /*
       * AMQP ключ для сообщений - id диалога
       */
      final String routingKey = command.dialog.id;

      final bindingData = AmqpBindingData(
          exchangeName: this._exchangeName,
          exchangeType: this._exchangeType,
          routingKeys: [routingKey]);

      this.updateState(NotificationReadyState<List<PrivateMessage>>(
          notifications: <PrivateMessage>[]));

      try {
        this._amqpConsumer =
            await amqpService.startListenBindedQueue(bindingData);

        // При обработке потока сообщений подтягиваются также необработанные
        // уведолмения из бд, в состояние кладется результирующий список
        StreamTransformer privateMessageTransformer =
            StreamTransformer.fromHandlers(
                handleData: (data, EventSink sink) async {
          final messageData = MbPrivateMessage.fromJson(data);
          final privateMessage = messageData.getPrivateMessage();

          if (this.currentState
              is NotificationReadyState<List<PrivateMessage>>) {
            final List<PrivateMessage> existing = List<PrivateMessage>.from(
                (this.currentState
                        as NotificationReadyState<List<PrivateMessage>>)
                    .notifications);
            existing.add(privateMessage);
            sink.add(NotificationReadyState<List<PrivateMessage>>(
                notifications: existing));
          } else {
            sink.add(NotificationReadyState<List<PrivateMessage>>(
                notifications: <PrivateMessage>[privateMessage]));
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
      } on Exception catch (e) {
        this.updateState(
            NotificationErrorState<List<PrivateMessage>>(error: e));
      }
    });

    /**
     * Обработка события подтверждения получения уведомления
     *
    this._ackNotificationReceivedEventStream.listen((event) async {
      final _event = event as AckNotificationReceived<List<PrivateMessage>>;

      List<PrivateMessage> receivedNotifications = _event.receivedNotification;

      try {
        final box = await Hive.openBox('private_msg_notifications');
        for (PrivateMessage msg in receivedNotifications) {
          box.delete(msg.id);
        }
        final List<PrivateMessage> notificationsList = box.values.toList();
        this.updateState(NotificationReadyState<List<PrivateMessage>>(
            notifications: notificationsList));
      } on Exception catch (e) {
        this.updateState(
            NotificationErrorState<List<PrivateMessage>>(error: e));
      }
    });*/
  }
}
