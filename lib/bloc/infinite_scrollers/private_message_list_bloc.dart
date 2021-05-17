import 'dart:math';

import 'package:lk_client/bloc/infinite_scrollers/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/state/consuming_state.dart';

class PrivateMessageListBloc extends AbstractEndlessScrollingBloc<PrivateMessage, LoadPrivateChatMessagesListCommand> {
  final PrivateChatMessagesListLoadingBloc _bloc;

  PrivateMessageListBloc(this._bloc);

  @override
  bool hasMoreChunks(ListedResponse<PrivateMessage> fresh) {
    return fresh.remains > 0;
  }

  @override
  LoadPrivateChatMessagesListCommand getNextChunkCommand(LoadPrivateChatMessagesListCommand previousCommand, ListedResponse<PrivateMessage> fresh) {
    LoadPrivateChatMessagesListCommand(
      dialog: previousCommand.dialog,
      count: min(previousCommand.count, fresh.remains),
      offset: previousCommand.offset + fresh.count
    );
  }

  @override
  List<PrivateMessage> copyPreviousToNew(List<PrivateMessage> previuos, List<PrivateMessage> fresh) {
    List<PrivateMessage> refresh = List<PrivateMessage>.from(previuos);
    refresh.addAll(fresh);
    return refresh;
  }

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
}