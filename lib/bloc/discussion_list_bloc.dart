import 'dart:math';

import 'package:lk_client/bloc/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/state/consuming_state.dart';

class DiscussionListBloc extends AbstractEndlessScrollingBloc<DiscussionMessage, LoadDisciplineDiscussionListCommand> {
  DiscussionLoadingBloc _bloc;

  DiscussionListBloc(this._bloc);

  @override
  bool hasMoreChunks(ListedResponse<DiscussionMessage> fresh) {
    return fresh.remains > 0;
  }

  @override
  List<DiscussionMessage> copyPreviousToNew(List<DiscussionMessage> previous, List<DiscussionMessage> fresh) {
    List<DiscussionMessage> refresh = List<DiscussionMessage>.from(previous);
    refresh.addAll(fresh);
    return refresh;
  }

  @override
  LoadDisciplineDiscussionListCommand getNextChunkCommand(LoadDisciplineDiscussionListCommand previousCommand, ListedResponse<DiscussionMessage> fresh) {
    return LoadDisciplineDiscussionListCommand(
      discipline: previousCommand.discipline,
      education: previousCommand.education,
      semester: previousCommand.semester,
      count: min(previousCommand.count, fresh.remains),
      offset: previousCommand.offset + fresh.count
    );
  }

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
}