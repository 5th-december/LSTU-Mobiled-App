import 'package:lk_client/bloc/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/state/consuming_state.dart';

class DialogListBloc extends AbstractEndlessScrollingBloc<Dialog, LoadDialogListCommand> {
  DialogListLoadingBloc _bloc;

  DialogListBloc(this._bloc);

  @override
  Future<ListedResponse<Dialog>> loadListElementChunk(LoadDialogListCommand command) async {
    this._bloc.eventController.sink.add(StartConsumeEvent<LoadDialogListCommand>(request: command));

    await for (ConsumingState<ListedResponse<Dialog>> event in this._bloc.consumingStateStream) {
      if(event is ConsumingErrorState<ListedResponse<Dialog>>) {
        throw new Exception('Data was not loaded');
      } else if(event is ConsumingReadyState<ListedResponse<Dialog>>) {
        return event.content;
      }
    }
  }

  @override
  bool hasMoreChunks(ListedResponse<Dialog> fresh) {
    return fresh.remains > 0;
  }

  @override
  ListedResponse<Dialog> copyPreviousToNew(ListedResponse<Dialog> previuos, ListedResponse<Dialog> fresh) {
    fresh.payload.insertAll(0, previuos.payload);
    return fresh;
  }
}