import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/mb_objects/mb_dialog.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/state/amqp_connection_storage.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class AmqpStartConsumeDialogListUpdates {
  Person receiver;
  AmqpStartConsumeDialogListUpdates({@required this.receiver});
}

class AmqpDialogListConsumerBloc extends AbstractBloc<
    NotificationConsumeState<List<Dialog>>, NotificationConsumeEvent> {
  Stream<NotificationConsumeState> get dialogListConsumingStateStream => this
      .stateContoller
      .stream
      .where((event) => event is NotificationConsumeState<List<Dialog>>);

  Stream<NotificationConsumeEvent> get _dialogListStartConsumingEvent =>
      this.eventController.stream.where((event) => event
          is StartNotificationConsumeEvent<AmqpStartConsumeDialogListUpdates>);

  Stream<NotificationConsumeEvent> get _ackDialogListNotificationEventStream =>
      this
          .eventController
          .stream
          .where((event) => event is AckNotificationReceived<List<Dialog>>);

  AmqpConnectionStorage amqpConnectionStorage;

  final exchangeType = ExchangeType.DIRECT;

  final exchangeName = 'dialog';

  StreamController dialogListController = StreamController();

  AmqpDialogListConsumerBloc({@required amqpConnectionStorage}) {
    /**
     * Событие старта подписки на обновление списка диалогов
     */
    this._dialogListStartConsumingEvent.listen((event) async {
      final _event = event
          as StartNotificationConsumeEvent<AmqpStartConsumeDialogListUpdates>;

      final command = _event.command;

      final String routingKey = command.receiver.id;

      final amqpBindingData = AmqpBindingData(
          exchangeName: this.exchangeName,
          exchangeType: this.exchangeType,
          routingKeys: [routingKey]);

      try {
        Stream<Map<dynamic, dynamic>> valuesStream =
            await this.amqpConnectionStorage.getConsumeStream(amqpBindingData);

        final transformer = StreamTransformer.fromHandlers(
            handleData: (data, EventSink sink) async {
          final createdDialogData = MbDialog.fromJson(data);
          final dialog = createdDialogData.getDialog();

          final box = await Hive.openBox('dialog_list_notifications');
          await box.put(dialog.id, dialog);
          final List<Dialog> notifiedDialogList = box.values.toList();

          sink.add(notifiedDialogList);
        });

        this.dialogListController.stream.transform(transformer).listen((event) {
          if (event is List<Dialog>) {
            this.updateState(
                NotificationReadyState<List<Dialog>>(notifications: event));
          }
        });

        valuesStream.listen((event) {
          this.dialogListController.sink.add(event);
        },
            onError: (e) => this
                .updateState(NotificationErrorState<List<Dialog>>(error: e)));
      } on Exception catch (e) {
        this.updateState(NotificationErrorState<List<Dialog>>(error: e));
      }
    });

    /**
     * Событие подтверждение получения от виджета
     */
    this._ackDialogListNotificationEventStream.listen((event) async {
      final _event = event as AckNotificationReceived<List<Dialog>>;
      List<Dialog> notifiedDialogs = _event.receivedNotification;

      try {
        final box = await Hive.openBox('dialog_list_notifications');
        for (Dialog notifiedDialog in notifiedDialogs) {
          box.delete(notifiedDialog.id);
        }

        final List<Dialog> notificationList = box.values.toList();
        this.updateState(NotificationReadyState<List<Dialog>>(
            notifications: notificationList));
      } on Exception catch (e) {
        this.updateState(NotificationErrorState<List<Dialog>>(error: e));
      }
    });
  }
}
