import 'dart:math';

import 'package:lk_client/bloc/infinite_scrollers/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/state/consuming_state.dart';

class DialogListBloc extends AbstractEndlessScrollingBloc<Dialog, LoadDialogListCommand> {
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
  LoadDialogListCommand getNextChunkCommand(LoadDialogListCommand previousCommand, ListedResponse<Dialog> fresh) {
    return LoadDialogListCommand(
      count: min(previousCommand.count, fresh.remains),
      offset: previousCommand.offset + fresh.count
    );
  }

  @override
  Future<ListedResponse<Dialog>> loadListElementChunk(LoadDialogListCommand command) async {
    this._bloc.eventController.sink.add(StartConsumeEvent<LoadDialogListCommand>(request: command));
    await for (ConsumingState<ListedResponse<Dialog>> event in this._bloc.consumingStateStream) {
      if(event is ConsumingErrorState<ListedResponse<Dialog>>) {
        throw event.error;
      } else if(event is ConsumingReadyState<ListedResponse<Dialog>>) {
        return event.content;
      }
    }
  }
}