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

class MbCDiscussionMessageConsumerBloc
    extends AbstractBloc<NotificationConsumeState, NotificationConsumeEvent> {
  /*
   * Тип exchange
   */
  final _exchangeType = ExchangeType.TOPIC;

  /*
   *  Наименование exchange
   */
  String _exchangeName;

  final StreamController _discussionController = StreamController();

  Consumer _amqpConsumer;

  @override
  dispose() {
    super.dispose();
    this._discussionController.close();
    this._amqpConsumer.cancel();
  }

  /*
   * Стрим состояний блока
   */
  Stream<NotificationConsumeState> get discussionMessageConsumingStateStream =>
      this.stateContoller.stream.where((event) =>
          event is NotificationConsumeState<List<DiscussionMessage>>);

  /*
   * Стрим событий старта потребления
   */
  Stream<NotificationConsumeEvent>
      get _discussionMessageStartConsumingEventStream => this
          .eventController
          .stream
          .where((event) => event is StartNotificationConsumeEvent<
              MbCStartConsumeDiscussionMessages>);

  /*
   * Стрим событий подтверждения получения уведолмений
   */
  Stream<NotificationConsumeEvent> get _ackDiscussionMessageNotification =>
      this.eventController.stream.where((event) =>
          event is AckPartiallyNotificationReceived<DiscussionMessage>);

  MbCDiscussionMessageConsumerBloc(
      {@required AmqpService amqpService, @required AmqpConfig amqpConfig}) {
    this._exchangeName = amqpConfig.discussionMessageExchangeName;

    /**
     * Стрим команд прослушивания
     */
    this._discussionMessageStartConsumingEventStream.listen((event) async {
      final _event = event
          as StartNotificationConsumeEvent<MbCStartConsumeDiscussionMessages>;
      final command = _event.command;

      /**
       * Клиент подписывается на все диалоги своей группы
       * Если периодов обучения несколько, дается список групп каждого периода обучения
       */
      final List<String> routingKeys = command.groups.map((e) => e.id).toList();

      final bindingData = AmqpBindingData(
          exchangeName: this._exchangeName,
          exchangeType: this._exchangeType,
          routingKeys: routingKeys);

      try {
        this._amqpConsumer =
            await amqpService.startListenBindedQueue(bindingData);

        /**
         * Трансформер для стрима Map<dynamic, dynamic> в List<DiscussionMessage>
         * с учетом данных прошлого состояния
         * в случае если прошлое состояние было успешным
         */
        StreamTransformer discussionMessageTransformer =
            StreamTransformer.fromHandlers(
                handleData: (data, EventSink sink) async {
          final DiscussionMessage discussionUpdate =
              DiscussionMessage.fromJson(data);

          if (this.currentState
              is NotificationReadyState<List<DiscussionMessage>>) {
            List<DiscussionMessage> existing = List<DiscussionMessage>.from(
                (this.currentState
                        as NotificationReadyState<List<DiscussionMessage>>)
                    .notifications);

            existing.add(discussionUpdate);

            sink.add(existing);
          } else {
            sink.add([discussionUpdate]);
          }
        });

        /**
         * Преобразование стрима и листенер на обновление стейта блока
         */
        this
            ._discussionController
            .stream
            .transform(discussionMessageTransformer)
            .listen((event) {
          if (event is List) {
            this.updateState(NotificationReadyState<List<DiscussionMessage>>(
                notifications: event.cast<DiscussionMessage>()));
          }
        });

        /**
         * Для каждого сообщения
         */
        this._amqpConsumer.listen((event) {
          this._discussionController.sink.add(event.payloadAsJson);
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

    this._ackDiscussionMessageNotification.listen((event) {
      final _event =
          event as AckPartiallyNotificationReceived<DiscussionMessage>;
      final ackNotificationsList = _event.deliveredNotifications;

      if (this.currentState
          is NotificationReadyState<List<DiscussionMessage>>) {
        final notificationsList = (this.currentState
                as NotificationReadyState<List<DiscussionMessage>>)
            .notifications;

        notificationsList
            .removeWhere((element) => ackNotificationsList.contains(element));

        this.updateState(NotificationReadyState<List<DiscussionMessage>>(
            notifications: notificationsList));
      }
    });
  }
}
