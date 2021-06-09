import 'dart:async';
import 'dart:math';

import 'package:lk_client/bloc/infinite_scrollers/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/state/consuming_state.dart';

class DialogListBloc
    extends AbstractEndlessScrollingBloc<Dialog, LoadDialogListCommand> {
  DialogListLoadingBloc _bloc;

  DialogListBloc(this._bloc);

  @override
  bool hasMoreChunks(ListedResponse<Dialog> fresh) {
    return fresh.remains > 0;
  }

  @override
  List<Dialog> copyPreviousToNew(List<Dialog> previuos, List<Dialog> fresh) {
    List<Dialog> refresh = List<Dialog>.from(previuos);
    refresh.addAll(fresh);
    return refresh;
  }

  @override
  LoadDialogListCommand getNextChunkCommand(
      LoadDialogListCommand previousCommand,
      LoadDialogListCommand currentCommand,
      List<Dialog> loaded,
      [int remains]) {
    return LoadDialogListCommand(
        count: min(currentCommand.count, remains), bound: loaded.last.id);
  }

  @override
  List<Dialog> addNewItemsToList(List<Dialog> actual, List<Dialog> additional) {
    final addedList = List<Dialog>.from(additional);
    addedList.addAll(actual);
    return addedList;
  }

  @override
  Future<ListedResponse<Dialog>> loadListElementChunk(
      LoadDialogListCommand command) async {
    this
        ._bloc
        .eventController
        .sink
        .add(StartConsumeEvent<LoadDialogListCommand>(request: command));

    Completer<ListedResponse<Dialog>> completer =
        Completer<ListedResponse<Dialog>>();

    Future.delayed(Duration.zero, () async {
      await for (ConsumingState<ListedResponse<Dialog>> event
          in this._bloc.consumingStateStream) {
        if (event is ConsumingErrorState<ListedResponse<Dialog>>) {
          completer.completeError(event.error);
          break;
        } else if (event is ConsumingReadyState<ListedResponse<Dialog>>) {
          completer.complete(event.content);
          break;
        }
      }
    });

    return completer.future;
  }
}
