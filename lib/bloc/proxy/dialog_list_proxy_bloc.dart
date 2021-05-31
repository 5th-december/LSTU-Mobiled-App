import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/amqp_consumers/amqp_dialog_start_consumer_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/dialog_list_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class DialogListProxyBloc extends AbstractBloc<dynamic, dynamic> {
  Stream<dynamic> get dialogListStateStream => this.stateContoller.stream;

  Stream<dynamic> get _dialogListLoadEventStream =>
      this.eventController.stream.where(
          (event) => event is EndlessScrollingLoadEvent<LoadDialogListCommand>);

  Stream<dynamic> get _dialogReadAcknowledgementEventStream => this
      .eventController
      .stream
      .where((event) => event is AckNotificationReceived<List<Dialog>>);

  final DialogListBloc loadingBloc;

  final AmqpDialogListConsumerBloc amqpListConsumerBloc;

  DialogListProxyBloc(
      {@required this.loadingBloc, @required this.amqpListConsumerBloc}) {
    this._dialogListLoadEventStream.listen((event) {
      final _event = event as EndlessScrollingLoadEvent;

      this.loadingBloc.eventController.sink.add(_event);

      if (event == this._dialogListLoadEventStream.first) {
        this.amqpListConsumerBloc.eventController.sink.add(
            StartNotificationConsumeEvent<AmqpStartConsumeDialogListUpdates>(
                command: AmqpStartConsumeDialogListUpdates(
                    receiver: _event.command.person)));

        this
            .amqpListConsumerBloc
            .dialogListConsumingStateStream
            .listen((event) {
          if (event is NotificationReadyState<List<Dialog>>) {
            this.loadingBloc.eventController.sink.add(
                ExternalDataAddEvent<Dialog>(
                    externalAddedData: event.notifications));
          }
        });

        this.loadingBloc.endlessListScrollingStateStream.listen((event) {
          this.updateState(event);
        });
      }
    });
  }
}
