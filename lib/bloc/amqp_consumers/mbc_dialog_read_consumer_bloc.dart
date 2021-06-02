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

class MbCStartConsumeDialogUpdates {
  Dialog watchedDialog;
  Person readerCompanion;
  MbCStartConsumeDialogUpdates(
      {@required this.watchedDialog, @required this.readerCompanion});
}

class MbCDialogReadConsumerBloc
    extends AbstractBloc<NotificationConsumeState, NotificationConsumeEvent> {
  final _exchangeType = ExchangeType.DIRECT;

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
  Stream<NotificationConsumeState> get dialogReadNotificationStateStream => this
      .stateContoller
      .stream
      .where((event) => event is NotificationConsumeState<List<Dialog>>);

  /*
   * Стрим событий подписки на уведомлений
   */
  Stream<NotificationConsumeEvent> get _dialogReadStartConsumingEventStream =>
      this.eventController.stream.where((event) =>
          event is StartNotificationConsumeEvent<MbCStartConsumeDialogUpdates>);

  /*
   * Стрим событий подтверждения получения уведомлений
   *
  Stream<NotificationConsumeEvent>
      get _ackDialogReadNotificationReceivedEventStream => this
          .eventController
          .where((event) => event is AckNotificationReceived<List<Dialog>>);*/

  MbCDialogReadConsumerBloc(
      {@required AmqpService amqpService, @required AmqpConfig config}) {
    this._exchangeName = config.dialogReadExchangeName;

    /**
     * События подписки на обновления
     */
    this._dialogReadStartConsumingEventStream.listen((event) async {
      final _event =
          event as StartNotificationConsumeEvent<MbCStartConsumeDialogUpdates>;

      final command = _event.command;

      final String routingKey =
          "${command.watchedDialog.id}.${command.readerCompanion.id}";

      final bindingData = AmqpBindingData(
          exchangeName: this._exchangeName,
          exchangeType: this._exchangeType,
          routingKeys: [routingKey]);

      this.updateState(
          NotificationReadyState<List<Dialog>>(notifications: <Dialog>[]));

      try {
        this._messageBrokerConsumer =
            await amqpService.startListenBindedQueue(bindingData);

        final dialogReadStreamTransformer =
            StreamTransformer.fromHandlers(handleData: (data, EventSink sink) {
          final dialogData = MbDialog.fromJson(data);
          final readDialog = dialogData.getDialog();

          if (this.currentState is NotificationReadyState<List<Dialog>>) {
            final existing = List<Dialog>.from(
                (this.currentState as NotificationReadyState<List<Dialog>>)
                    .notifications);
            existing.add(readDialog);
            sink.add(existing);
          } else {
            sink.add(NotificationReadyState<List<Dialog>>(
                notifications: <Dialog>[readDialog]));
          }
        });

        this
            ._dialogReadController
            .stream
            .transform(dialogReadStreamTransformer)
            .listen((event) {
          if (event is List) {
            this.updateState(NotificationReadyState<List<Dialog>>(
                notifications: event.cast<Dialog>()));
          }
        });

        this._messageBrokerConsumer.listen((event) {
          this._dialogReadController.sink.add(event.payloadAsJson);
        });
      } on Exception catch (e) {
        this.updateState(NotificationErrorState<List<Dialog>>(error: e));
      }
    });

    /**
     * Подписчик событий получения уведомления
     */
    //this._ackDialogReadNotificationReceivedEventStream.listen((event) {});
  }
}
