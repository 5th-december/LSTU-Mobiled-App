import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/dialog_list_bloc.dart';
import 'package:lk_client/bloc/message_broker_consumers/mbc_dialog_list_consumer_bloc.dart';
import 'package:lk_client/bloc_container/mbc_dialog_list_bloc_container.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/event/proxy_event.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class DialogListProxyBloc extends AbstractBloc<dynamic, dynamic> {
  /*
   * Проксирует стрим состояний блока загрузки 
   */
  Stream<dynamic> get dialogListStateStream => this.stateContoller.stream;

  /*
   * Проксирует стрим передачи событий инициализации блоку загрузки + инициализирует
   * и вешает обработчик на стрим уведомлений
   */
  Stream<dynamic> get _dialogListInitEventStream => this
      .eventController
      .stream
      .where((event) => event is ProxyInitEvent<StartNotifyOnPerson>);

  /*
   * Проксирует стрим передачи событий на загрузку списка в loading bloc 
   */
  Stream<dynamic> get _dialogListLoadEventStream => this
      .eventController
      .stream
      .where((event) => event is LoadChunkEvent<LoadDialogListCommand>);

  final DialogListBloc loadingBloc;

  /*
   * Получает доступ к блоку из notification bloc provider 
   */
  final MbCDialogListConsumerBloc mbcDialogListConsumerBloc;

  static Future<DialogListProxyBloc> init(
      {@required
          DialogListBloc dialogListBloc,
      @required
          Future<MbCDialogListBlocContainer>
              mbCDialogListBlocContainer}) async {
    MbCDialogListBlocContainer _mbCDialogListBlocContainer =
        await mbCDialogListBlocContainer;
    MbCDialogListConsumerBloc mbCDialogListConsumerBloc =
        _mbCDialogListBlocContainer.getBloc();
    final pb = DialogListProxyBloc(
        loadingBloc: dialogListBloc,
        mbcDialogListConsumerBloc: mbCDialogListConsumerBloc);
    return pb;
  }

  DialogListProxyBloc(
      {@required this.loadingBloc, @required this.mbcDialogListConsumerBloc}) {
    this._dialogListInitEventStream.listen((event) {
      /**
       * При отправке событий инициализации списка подписывается на 
       * стрим событий блока событий + при возникновении нового диалога передает в 
       * блок списка событие внешнего добавления данных
       */
      this
          .mbcDialogListConsumerBloc
          .dialogListConsumingStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<Dialog>> &&
            event.notifications.length != 0) {
          this.loadingBloc.eventController.sink.add(
              ExternalDataAddEvent<Dialog>(
                  externalAddedData: event.notifications));

          this
              .mbcDialogListConsumerBloc
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
      this.loadingBloc.eventController.sink.add(event);
    });
  }
}
