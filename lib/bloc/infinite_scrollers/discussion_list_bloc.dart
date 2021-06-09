import 'dart:async';
import 'dart:math';

import 'package:lk_client/bloc/infinite_scrollers/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/state/consuming_state.dart';

class DiscussionListBloc extends AbstractEndlessScrollingBloc<DiscussionMessage,
    LoadDisciplineDiscussionListCommand> {
  DiscussionLoadingBloc _bloc;

  DiscussionListBloc(this._bloc);

  @override
  bool hasMoreChunks(ListedResponse<DiscussionMessage> fresh) {
    return fresh.remains > 0;
  }

  @override
  List<DiscussionMessage> copyPreviousToNew(
      List<DiscussionMessage> previous, List<DiscussionMessage> fresh) {
    List<DiscussionMessage> refresh = List<DiscussionMessage>.from(previous);
    refresh.addAll(fresh);
    return refresh;
  }

  @override
  LoadDisciplineDiscussionListCommand getNextChunkCommand(
      LoadDisciplineDiscussionListCommand previousCommand,
      LoadDisciplineDiscussionListCommand currentCommand,
      List<DiscussionMessage> loaded,
      [int remains]) {
    return LoadDisciplineDiscussionListCommand(
        discipline: previousCommand.discipline,
        education: previousCommand.education,
        semester: previousCommand.semester,
        count: min(currentCommand.count, remains),
        bound: loaded.last.id);
  }

  @override
  List<DiscussionMessage> addNewItemsToList(
      List<DiscussionMessage> actual, List<DiscussionMessage> additional) {
    final addedList = List<DiscussionMessage>.from(additional);
    addedList.addAll(actual);
    return addedList;
  }

  @override
  Future<ListedResponse<DiscussionMessage>> loadListElementChunk(
      LoadDisciplineDiscussionListCommand command) async {
    this._bloc.eventController.sink.add(
        StartConsumeEvent<LoadDisciplineDiscussionListCommand>(
            request: command));
    Completer<ListedResponse<DiscussionMessage>> completer =
        Completer<ListedResponse<DiscussionMessage>>();

    Future.delayed(Duration.zero, () async {
      await for (ConsumingState<ListedResponse<DiscussionMessage>> event
          in this._bloc.consumingStateStream) {
        if (event is ConsumingErrorState<ListedResponse<DiscussionMessage>>) {
          completer.completeError(event.error);
          break;
        } else if (event
            is ConsumingReadyState<ListedResponse<DiscussionMessage>>) {
          completer.complete(event.content);
          break;
        }
      }
    });

    return completer.future;
  }
}
