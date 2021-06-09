import 'dart:async';
import 'dart:math';

import 'package:lk_client/bloc/infinite_scrollers/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/state/consuming_state.dart';

class PrivateMessageListBloc extends AbstractEndlessScrollingBloc<
    PrivateMessage, LoadPrivateChatMessagesListCommand> {
  final PrivateChatMessagesListLoadingBloc _bloc;

  PrivateMessageListBloc(this._bloc);

  @override
  bool hasMoreChunks(ListedResponse<PrivateMessage> fresh) {
    return fresh.remains > 0;
  }

  @override
  LoadPrivateChatMessagesListCommand getNextChunkCommand(
      LoadPrivateChatMessagesListCommand previousCommand,
      LoadPrivateChatMessagesListCommand currentCommand,
      List<PrivateMessage> loaded,
      [int remains]) {
    return LoadPrivateChatMessagesListCommand(
        dialog: previousCommand.dialog,
        count: min(currentCommand.count, remains),
        bound: loaded.last.id);
  }

  @override
  List<PrivateMessage> copyPreviousToNew(
      List<PrivateMessage> previuos, List<PrivateMessage> fresh) {
    List<PrivateMessage> refresh = List<PrivateMessage>.from(previuos);
    refresh.addAll(fresh);
    return refresh;
  }

  @override
  List<PrivateMessage> addNewItemsToList(
      List<PrivateMessage> actual, List<PrivateMessage> additional) {
    final addedList = List<PrivateMessage>.from(additional);
    addedList.addAll(actual);
    return addedList;
  }

  @override
  List<PrivateMessage> updateItemsInList(
      List<PrivateMessage> actual, List<PrivateMessage> update) {
    for (int i = 0; i != actual.length; ++i) {
      final replacer = update.firstWhere(
          (element) => element.id == actual[i].id,
          orElse: () => null);
      if (replacer != null) {
        actual[i] = replacer;
      }
    }
    return actual;
  }

  @override
  Future<ListedResponse<PrivateMessage>> loadListElementChunk(
      LoadPrivateChatMessagesListCommand command) async {
    this._bloc.eventController.sink.add(
        StartConsumeEvent<LoadPrivateChatMessagesListCommand>(
            request: command));

    Completer<ListedResponse<PrivateMessage>> completer =
        Completer<ListedResponse<PrivateMessage>>();

    Future.delayed(Duration.zero, () async {
      await for (ConsumingState<ListedResponse<PrivateMessage>> event
          in this._bloc.consumingStateStream) {
        if (event is ConsumingErrorState<ListedResponse<PrivateMessage>>) {
          completer.completeError(event.error);
          break;
        } else if (event
            is ConsumingReadyState<ListedResponse<PrivateMessage>>) {
          completer.complete(event.content);
          break;
        }
      }
    });

    return completer.future;
  }
}
