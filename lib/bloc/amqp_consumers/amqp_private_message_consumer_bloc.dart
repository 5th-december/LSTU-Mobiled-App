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
import 'package:lk_client/state/amqp_connection_storage.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class AmqpStartConsumeDialogMessages {
  final Dialog dialog;
  AmqpStartConsumeDialogMessages({@required this.dialog});
}

class AmqpPrivateMessageConsumerBloc
    extends AbstractBloc<NotificationConsumeState, NotificationConsumeEvent> {
  // Состояние наличия уведомлений
  Stream<NotificationConsumeState> get privateMessageConsumingStateStream =>
      this.stateContoller.stream.where(
          (event) => event is NotificationConsumeState<List<PrivateMessage>>);

  // Стрим событий подписки на уведомления
  Stream<NotificationConsumeEvent>
      get _privateMessageStartConsumingEventStream =>
          this.eventController.stream.where((event) => event
              is StartNotificationConsumeEvent<AmqpStartConsumeDialogMessages>);

  // Стрим событий подтверждения получения уведомлений
  Stream<NotificationConsumeEvent> get _ackNotificationReceivedEventStream =>
      this.eventController.stream.where(
          (event) => event is AckNotificationReceived<List<PrivateMessage>>);

  // Тип exchange
  final exchangeType = ExchangeType.DIRECT;
  // Наименование exchange
  final exchangeName = 'private_msg';

  final StreamController messageController = StreamController();

  AmqpConnectionStorage amqpConnectionStorage;

  AmqpPrivateMessageConsumerBloc({@required this.amqpConnectionStorage}) {
    /**
     * Событие старта подписки на обновления
     */
    this._privateMessageStartConsumingEventStream.listen((event) async {
      final _event = event
          as StartNotificationConsumeEvent<AmqpStartConsumeDialogMessages>;
      final command = _event.command;

      // amqp ключ для сообщений - id диалога
      final String routingKey = command.dialog.id;

      final bindingData = AmqpBindingData(
          exchangeName: this.exchangeName,
          exchangeType: this.exchangeType,
          routingKeys: [routingKey]);

      try {
        Stream<Map<dynamic, dynamic>> valuesStream =
            await this.amqpConnectionStorage.getConsumeStream(bindingData);

        // При обработке потока сообщений подтягиваются также необработанные
        // уведолмения из бд, в состояние кладется результирующий список
        StreamTransformer privateMessageTransformer =
            StreamTransformer.fromHandlers(
                handleData: (data, EventSink sink) async {
          final messageData = MbPrivateMessage.fromJson(data);
          final privateMessage = messageData.getPrivateMessage();

          final box = await Hive.openBox('private_msg_notifications');
          await box.put(privateMessage.id, privateMessage);
          final List<PrivateMessage> notificationsList = box.values.toList();

          sink.add(notificationsList);
        });

        this
            .messageController
            .stream
            .transform(privateMessageTransformer)
            .listen((event) {
          if (event is List<PrivateMessage>) {
            this.updateState(NotificationReadyState<List<PrivateMessage>>(
                notifications: event));
          }
        });

        valuesStream.listen((event) {
          this.messageController.sink.add(event);
        },
            onError: (e) => this
                .updateState(NotificationErrorState<List<Dialog>>(error: e)));

        final box = await Hive.openBox('private_msg_notifications');
        this.updateState(NotificationReadyState<List<PrivateMessage>>(
            notifications: box.values.toList()));
      } on Exception catch (e) {
        this.updateState(
            NotificationErrorState<List<PrivateMessage>>(error: e));
      }
    });

    /**
     * Обработка события подтверждения получения уведомления
     */
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
    });
  }
}
