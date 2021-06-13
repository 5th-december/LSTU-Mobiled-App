import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/message_broker_consumers/mbc_private_message_consumer_bloc.dart';
import 'package:lk_client/bloc_container/mbc_private_message_bloc_container.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class ResetCounterEvent<T> {
  final T value;
  ResetCounterEvent({@required this.value});
}

class MessengerTileUnreadBloc
    extends AbstractBloc<ConsumingState<int>, dynamic> {
  Stream<ConsumingState<int>> get messengerUnreadCountStateStream =>
      this.stateContoller.stream.where((event) => event is ConsumingState<int>);

  Stream<dynamic> get _initMessageUnreadCountEventStream => this
      .eventController
      .stream
      .where((event) => event is StartConsumeEvent<Dialog>);

  Stream<dynamic> get _resetCounterEventStream => this
      .eventController
      .stream
      .where((event) => event is ResetCounterEvent<int>);

  int _lastAddedCount = 0;

  static Future<MessengerTileUnreadBloc> init(
      {@required
          Future<MbCPrivateMessageBlocContainer> privateMessageBlocContainer,
      @required
          Dialog dialog,
      @required
          Person person}) async {
    MbCPrivateMessageBlocContainer _privateMessageBlocContainer =
        await privateMessageBlocContainer;
    MbCPrivateMessageConsumerBloc privateMessageConsumerBloc =
        await _privateMessageBlocContainer.getBloc(dialog, person);
    return MessengerTileUnreadBloc(
        privateMessageConsumerBloc: privateMessageConsumerBloc);
  }

  MessengerTileUnreadBloc(
      {@required MbCPrivateMessageConsumerBloc privateMessageConsumerBloc}) {
    this._initMessageUnreadCountEventStream.listen((event) {
      final watchingDialog = (event as StartConsumeEvent<Dialog>).request;

      if (watchingDialog.unreadCount != null &&
          watchingDialog.unreadCount != 0) {
        this.updateState(ConsumingReadyState<int>(watchingDialog.unreadCount));
      } else {
        this.updateState(ConsumingInitState<int>());
      }

      privateMessageConsumerBloc.privateMessageConsumingStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<PrivateMessage>> &&
            event.notifications.length != 0 &&
            !event.notifications[0].meSender) {
          if (this.currentState is ConsumingReadyState<int>) {
            int currentValue =
                (this.currentState as ConsumingReadyState<int>).content;
            this.updateState(ConsumingReadyState<int>(currentValue -
                this._lastAddedCount +
                event.notifications.length));
          } else if (this.currentState is ConsumingInitState<int>) {
            this.updateState(
                ConsumingReadyState<int>(event.notifications.length));
          }
          this._lastAddedCount = event.notifications.length;
        }
      });
    });

    this._resetCounterEventStream.listen((event) {
      this._lastAddedCount = 0;
      this.updateState(ConsumingInitState<int>());
    });
  }
}
