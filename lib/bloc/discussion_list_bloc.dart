import 'package:lk_client/bloc/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/state/consuming_state.dart';

class DiscussionListBloc extends AbstractEndlessScrollingBloc<DiscussionMessage, LoadDisciplineDiscussionListCommand> {
  DiscussionLoadingBloc _bloc;

  DiscussionListBloc(this._bloc);

  @override
  Future<ListedResponse<DiscussionMessage>> loadListElementChunk(LoadDisciplineDiscussionListCommand command) async {
    this._bloc.eventController.sink.add(StartConsumeEvent<LoadDisciplineDiscussionListCommand>(request: command));

    await for(ConsumingState<ListedResponse<DiscussionMessage>> event in this._bloc.consumingStateStream) {
      if(event is ConsumingErrorState<ListedResponse<DiscussionMessage>>) {
        throw Exception('Data was not loaded');
      } else if (event is ConsumingReadyState<ListedResponse<DiscussionMessage>>) {
        return event.content;
      }
    }
  }

  @override
  bool hasMoreChunks(ListedResponse<DiscussionMessage> fresh) {
    return fresh.remains > 0;
  }

  @override
  ListedResponse<DiscussionMessage> copyPreviousToNew(ListedResponse<DiscussionMessage> previous, ListedResponse<DiscussionMessage> fresh) {
    fresh.payload.insertAll(0, previous.payload);
    return fresh;
  }
}