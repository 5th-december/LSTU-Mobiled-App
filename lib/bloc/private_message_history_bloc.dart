import 'package:lk_client/bloc/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/state/consuming_state.dart';

class PrivateMessageHistoryBloc extends AbstractEndlessScrollingBloc<PrivateMessage, LoadPrivateChatMessagesListCommand> {
  final PrivateChatMessagesListLoadingBloc _bloc;

  PrivateMessageHistoryBloc(this._bloc);

  @override
  Future<ListedResponse<PrivateMessage>> loadListElementChunk(LoadPrivateChatMessagesListCommand command) async {
    this._bloc.eventController.sink.add(StartConsumeEvent<LoadPrivateChatMessagesListCommand>(request: command));

    await for (ConsumingState<ListedResponse<PrivateMessage>> event in this._bloc.consumingStateStream) {
      if(event is ConsumingErrorState<ListedResponse<PrivateMessage>>) {
        throw Exception('Data not loaded');
      } else if (event is ConsumingReadyState<ListedResponse<PrivateMessage>>) {
        return event.content;
      }
    }
  }

  @override
  bool hasMoreChunks(ListedResponse<PrivateMessage> fresh) {
    return fresh.remains > 0;
  }

  @override
  ListedResponse<PrivateMessage> copyPreviousToNew(
    ListedResponse<PrivateMessage> previuos, ListedResponse<PrivateMessage> fresh) {
      fresh.payload.insertAll(0, previuos.payload);
      return fresh;
  }
}