import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/amqp_consumers/amqp_dialog_start_consumer_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/dialog_list_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class StartNotifyOnPerson {
  Person trackedPerson;
  StartNotifyOnPerson({@required this.trackedPerson});
}

class DialogListProxyBloc extends AbstractBloc<dynamic, dynamic> {
  /*
   * Проксирует стрим состояний блока загрузки 
   */
  Stream<dynamic> get dialogListStateStream => this.stateContoller.stream;

  /*
   * Проксирует стрим передачи событий инициализации блоку загрузки + инициализирует
   * и вешает обработчик на стрим уведомлений
   */
  Stream<dynamic> get _dialogListInitEventStream =>
      this.eventController.stream.where(
          (event) => event is EndlessScrollingLoadEvent<StartNotifyOnPerson>);

  /*
   * Проксирует стрим передачи событий на загрузку списка в loading bloc 
   */
  Stream<dynamic> get _dialogListLoadEventStream =>
      this.eventController.stream.where(
          (event) => event is EndlessScrollingLoadEvent<LoadDialogListCommand>);

  final DialogListBloc loadingBloc;

  /*
   * Получает доступ к блоку из notification bloc provider 
   */
  final AmqpDialogListConsumerBloc amqpListConsumerBloc;

  DialogListProxyBloc(
      {@required this.loadingBloc, @required this.amqpListConsumerBloc}) {
    this._dialogListInitEventStream.listen((event) {
      /**
       * При отправке событий инициализации списка подписывается на 
       * стрим событий блока событий + при возникновении нового диалога передает в 
       * блок списка событие внешнего добавления данных
       */
      final _event = event as EndlessScrollingLoadEvent<StartNotifyOnPerson>;

      this.amqpListConsumerBloc.eventController.sink.add(
          StartNotificationConsumeEvent<AmqpStartConsumeDialogListUpdates>(
              command: AmqpStartConsumeDialogListUpdates(
                  receiver: _event.command.trackedPerson)));

      this.amqpListConsumerBloc.dialogListConsumingStateStream.listen((event) {
        if (event is NotificationReadyState<List<Dialog>> &&
            event.notifications.length != 0) {
          this.loadingBloc.eventController.sink.add(
              ExternalDataAddEvent<Dialog>(
                  externalAddedData: event.notifications));

          this
              .amqpListConsumerBloc
              .eventController
              .sink
              .add(AckAllNotificationReceived());
        }
      });

      /**
       * Также инициализируется начальным состоянием блок загрузки
       */
      this.loadingBloc.eventController.add(EndlessScrollingInitEvent<Dialog>());

      /**
       * И на его поток событий напрямую вешается поток событий данного прокси виджета
       */
      this.loadingBloc.endlessListScrollingStateStream.listen((event) {
        this.updateState(event);
      });
    });

    this._dialogListLoadEventStream.listen((event) {
      final _event = event as EndlessScrollingLoadEvent;
      this.loadingBloc.eventController.sink.add(_event);
    });
  }
}
