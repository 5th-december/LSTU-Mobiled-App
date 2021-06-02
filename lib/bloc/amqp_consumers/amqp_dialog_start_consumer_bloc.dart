import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/mb_objects/mb_dialog.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/config/amqp_config.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class AmqpStartConsumeDialogListUpdates {
  Person receiver;
  AmqpStartConsumeDialogListUpdates({@required this.receiver});
}

class AmqpDialogListConsumerBloc extends AbstractBloc<
    NotificationConsumeState<List<Dialog>>, NotificationConsumeEvent> {
  final _exchangeType = ExchangeType.DIRECT;

  String _exchangeName;

  StreamController _dialogListController = StreamController();

  Consumer _amqpConsumer;

  @override
  dispose() {
    super.dispose();
    this._dialogListController.close();
    this._amqpConsumer.cancel();
  }

  /*
   * Стрим состояний
   */
  Stream<NotificationConsumeState> get dialogListConsumingStateStream => this
      .stateContoller
      .stream
      .where((event) => event is NotificationConsumeState<List<Dialog>>);

  /*
   * Стрим событий потребления
   */
  Stream<NotificationConsumeEvent> get _dialogListStartConsumingEvent =>
      this.eventController.stream.where((event) => event
          is StartNotificationConsumeEvent<AmqpStartConsumeDialogListUpdates>);

  /*
   * Стрим событий подтверждения 
   */
  Stream<NotificationConsumeEvent>
      get _ackAllDialogListNotificationEventStream => this
          .eventController
          .stream
          .where((event) => event is AckAllNotificationReceived);

  AmqpDialogListConsumerBloc(
      {@required AmqpService amqpService, @required AmqpConfig amqpConfig}) {
    this._exchangeName = amqpConfig.dialogListExchangeName;
    /**
     * Событие старта подписки на обновление списка диалогов
     */
    this._dialogListStartConsumingEvent.listen((event) async {
      final _event = event
          as StartNotificationConsumeEvent<AmqpStartConsumeDialogListUpdates>;

      final command = _event.command;

      final String routingKey = command.receiver.id;

      final amqpBindingData = AmqpBindingData(
          exchangeName: this._exchangeName,
          exchangeType: this._exchangeType,
          routingKeys: [routingKey]);

      try {
        this._amqpConsumer =
            await amqpService.startListenBindedQueue(amqpBindingData);

        final transformer = StreamTransformer.fromHandlers(
            handleData: (data, EventSink sink) async {
          final createdDialogData = MbDialog.fromJson(data);
          final dialog = createdDialogData.getDialog();

          if (this.currentState is NotificationReadyState<List<Dialog>> &&
              (this.currentState as NotificationReadyState<List<Dialog>>)
                      .notifications
                      .length !=
                  0) {
            List<Dialog> existing = List<Dialog>.from(
                (this.currentState as NotificationReadyState<List<Dialog>>)
                    .notifications);
            existing.add(dialog);
            sink.add(existing);
          } else {
            sink.add(<Dialog>[dialog]);
          }
        });

        this
            ._dialogListController
            .stream
            .transform(transformer)
            .listen((event) {
          if (event is List) {
            this.updateState(NotificationReadyState<List<Dialog>>(
                notifications: event.cast<Dialog>()));
          }
        });

        this._amqpConsumer.listen((event) {
          this._dialogListController.sink.add(event.payloadAsJson);
        },
            onError: (e) => this
                .updateState(NotificationErrorState<List<Dialog>>(error: e)));
      } on Exception catch (e) {
        this.updateState(NotificationErrorState<List<Dialog>>(error: e));
      }
    });

    /**
     * Событие подтверждения получения от виджета
     */
    this._ackAllDialogListNotificationEventStream.listen((event) async {
      if (this.currentState is NotificationReadyState<List<Dialog>>) {
        this.updateState(NotificationReadyState<List<Dialog>>(
            notifications: const <Dialog>[]));
      }
    });
  }
}
