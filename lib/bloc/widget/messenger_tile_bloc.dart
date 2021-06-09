import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/message_broker_consumers/mbc_chat_update_consumer_bloc.dart';
import 'package:lk_client/bloc/message_broker_consumers/mbc_private_message_consumer_bloc.dart';
import 'package:lk_client/bloc_container/mbc_chat_update_bloc_container.dart';
import 'package:lk_client/bloc_container/mbc_private_message_bloc_container.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class MessengerTileBloc extends AbstractBloc<ConsumingState<PrivateMessage>,
    ConsumingEvent<Dialog>> {
  final MbCChatUpdateConsumerBloc chatUpdateConsumerBloc;
  final MbCPrivateMessageConsumerBloc privateMessageConsumerBloc;

  Stream<ConsumingState<PrivateMessage>> get messageUpdateStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ConsumingState<PrivateMessage>);

  Stream<ConsumingEvent<Dialog>> get _initNewPrivateMessageSubscriptionStream =>
      this
          .eventController
          .stream
          .where((event) => event is StartConsumeEvent<Dialog>);

  static Future<MessengerTileBloc> init(
      {@required
          Future<MbCChatUpdateBlocContainer> chatUpdateBlocContainer,
      @required
          Future<MbCPrivateMessageBlocContainer> privateMessageBlocContainer,
      @required
          Dialog dialog,
      @required
          Person person}) async {
    final _chatUpdateBlocContainer = await chatUpdateBlocContainer;
    final chatUpdateConsumerBloc =
        await _chatUpdateBlocContainer.getBloc(dialog, person);
    final _privateMessageBlocContainer = await privateMessageBlocContainer;
    final privateMessageConsumerBloc =
        await _privateMessageBlocContainer.getBloc(dialog, person);
    return MessengerTileBloc(
        chatUpdateConsumerBloc: chatUpdateConsumerBloc,
        privateMessageConsumerBloc: privateMessageConsumerBloc);
  }

  /*
   * Блок элемента списка последнего сообщения в списке диалогов
   * осуществляет доставку последнего загруженного из апи сообщения 
   * и вешает слушателя на события доставки сообщений 
   * и обновления сообщений в брокере сообщений 
   */
  MessengerTileBloc(
      {@required this.chatUpdateConsumerBloc, // блок обновления состояния чата
      @required this.privateMessageConsumerBloc}) {
    // блок обновления списка сообщений
    this._initNewPrivateMessageSubscriptionStream.listen((event) {
      final _event = event as StartConsumeEvent<Dialog>;

      final subscribedDialog = _event.request;
      if (subscribedDialog.lastMessage != null) {
        this.updateState(
            ConsumingReadyState<PrivateMessage>(subscribedDialog.lastMessage));
      }

      this
          .privateMessageConsumerBloc
          .privateMessageConsumingStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<PrivateMessage>>) {
          final loadedNotificationList = event.notifications;
          if (loadedNotificationList.length != 0) {
            // Для каждого события получения нового сообщения
            // выбирается последнее из них
            final lastMessage = loadedNotificationList.first;
            // В случае, если текущее состояние уже содержит
            //сообщение с данным идентификатором, не обновлять состояние
            if (this.currentState is ConsumingReadyState<PrivateMessage> &&
                (this.currentState as ConsumingReadyState<PrivateMessage>)
                        .content
                        .id ==
                    lastMessage.id) {
              return;
            }

            this.updateState(ConsumingReadyState<PrivateMessage>(lastMessage));
          }
        }
      });

      this
          .chatUpdateConsumerBloc
          .dialogReadNotificationStateStream
          .listen((event) {
        if (event is NotificationReadyState<List<PrivateMessage>>) {
          final updatedMessagesList = event.notifications;
          if (this.currentState is ConsumingReadyState<PrivateMessage>) {
            final lastMessage =
                (this.currentState as ConsumingReadyState<PrivateMessage>)
                    .content;
            final actualUpdatedMessage = updatedMessagesList.firstWhere(
                (element) => element.id == lastMessage.id,
                orElse: () => null);
            if (actualUpdatedMessage != null) {
              this.updateState(
                  ConsumingReadyState<PrivateMessage>(actualUpdatedMessage));
            }
          }
        }
      });
    });
  }
}
