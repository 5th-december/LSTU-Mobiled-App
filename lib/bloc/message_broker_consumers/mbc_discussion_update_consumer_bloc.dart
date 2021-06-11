import 'dart:async';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/mbc_command.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/config/amqp_config.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class MbCDiscussionUpdateConsumerBloc
    extends AbstractBloc<NotificationConsumeState, NotificationConsumeEvent> {
  final _exchangeType = ExchangeType.TOPIC;

  String _exchangeName;

  final StreamController _discussionUpdatesReadController = StreamController();

  Consumer _messageBrokerConsumer;

  @override
  dispose() {
    super.dispose();
    this._discussionUpdatesReadController.close();
    this._messageBrokerConsumer.cancel();
  }

  /*
   * Стрим состояний уведомлений
   */
  Stream<NotificationConsumeState>
      get discissionUpdateNotificationStateStream =>
          this.stateContoller.stream.where((event) =>
              event is NotificationConsumeState<List<DiscussionMessage>>);

  /*
   * Стрим событий подписки на уведомлений
   */
  Stream<NotificationConsumeEvent>
      get _discussionUpdateStartConsumingEventStream => this
          .eventController
          .stream
          .where((event) => event is StartNotificationConsumeEvent<
              MbCStartConsumeDiscussionUpdates>);

  /*
   * Стрим событий подтверждения получения уведомлений
   */
  Stream<NotificationConsumeEvent>
      get _ackDiscussionUpdatePartiallyReceivedEventStream =>
          this.eventController.where((event) =>
              event is AckPartiallyNotificationReceived<DiscussionMessage>);

  MbCDiscussionUpdateConsumerBloc(
      {@required AmqpService amqpService, @required AmqpConfig amqpConfig}) {
    this._exchangeName = amqpConfig.discussionMessageUpdateExchangeName;

    /**
     * События подписки на обновления
     */
    this._discussionUpdateStartConsumingEventStream.listen((event) async {
      final _event = event
          as StartNotificationConsumeEvent<MbCStartConsumeDiscussionUpdates>;

      final command = _event.command;

      final List<String> routingKeys = command.groups.map((e) => e.id).toList();

      final bindingData = AmqpBindingData(
          exchangeName: this._exchangeName,
          exchangeType: this._exchangeType,
          routingKeys: routingKeys);

      try {
        this._messageBrokerConsumer =
            await amqpService.startConsumePrivateQueue(bindingData);

        final dialogReadStreamTransformer =
            StreamTransformer.fromHandlers(handleData: (data, EventSink sink) {
          final updatedDiscussionMessage = DiscussionMessage.fromJson(data);

          if (this.currentState
              is NotificationReadyState<List<DiscussionMessage>>) {
            final existing = List<DiscussionMessage>.from((this.currentState
                    as NotificationReadyState<List<DiscussionMessage>>)
                .notifications);
            existing.add(updatedDiscussionMessage);
            sink.add(existing);
          } else {
            sink.add(<DiscussionMessage>[updatedDiscussionMessage]);
          }
        });

        this
            ._discussionUpdatesReadController
            .stream
            .transform(dialogReadStreamTransformer)
            .listen((event) {
          if (event is List) {
            this.updateState(NotificationReadyState<List<DiscussionMessage>>(
                notifications: event.cast<DiscussionMessage>()));
          }
        });

        this._messageBrokerConsumer.listen((event) {
          this._discussionUpdatesReadController.sink.add(event.payloadAsJson);
        },
            onError: (e) => this.updateState(
                NotificationErrorState<List<DiscussionMessage>>(error: e)));

        this.updateState(NotificationReadyState<List<DiscussionMessage>>(
            notifications: <DiscussionMessage>[]));
      } on Exception catch (e) {
        this.updateState(
            NotificationErrorState<List<DiscussionMessage>>(error: e));
      }
    });

    this._ackDiscussionUpdatePartiallyReceivedEventStream.listen((event) {
      if (this.currentState
              is NotificationReadyState<List<DiscussionMessage>> &&
          (this.currentState as NotificationReadyState<List<DiscussionMessage>>)
                  .notifications
                  .length !=
              0) {
        final currentNotifications = (this.currentState
                as NotificationReadyState<List<DiscussionMessage>>)
            .notifications;
        final consumedNotifications =
            (event as AckPartiallyNotificationReceived<DiscussionMessage>)
                .deliveredNotifications;
        currentNotifications.removeWhere((DiscussionMessage element) =>
            consumedNotifications.firstWhere(
                (DiscussionMessage consumed) => consumed.id == element.id,
                orElse: () => null) !=
            null);
        this.updateState(NotificationReadyState<List<DiscussionMessage>>(
            notifications: currentNotifications));
      }
    });
  }
}
