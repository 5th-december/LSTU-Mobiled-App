import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/discussion_list_bloc.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/message_bubble_widget.dart';
import 'package:lk_client/widget/list/endless_scrolling_widget.dart';

class DiscussionMessageList extends StatefulWidget {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  final Person loggedPerson;

  DiscussionMessageList({
    Key key, 
    @required this.discipline,
    @required this.education,
    @required this.semester,
    @required this.loggedPerson
  }): super(key: key);

  @override
  _DiscussionMessageList createState() => _DiscussionMessageList();
}

class _DiscussionMessageList extends State<DiscussionMessageList> {
  DiscussionListBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._bloc == null) {
      MessengerQueryService messengerQueryService = AppStateContainer.of(context).serviceProvider.messengerQueryService;
      DiscussionLoadingBloc discussionLoadingBloc = DiscussionLoadingBloc(messengerQueryService);
      this._bloc = DiscussionListBloc(discussionLoadingBloc);
    }
  }

  EndlessScrollingLoadChunkEvent<LoadDisciplineDiscussionListCommand> getLoadCommand
    ([ListedResponse<DiscussionMessage> currentState]) {
      final int lastLoaded = currentState?.nextOffset ?? 0;
      LoadDisciplineDiscussionListCommand command = LoadDisciplineDiscussionListCommand(
        count: 50,
        offset: lastLoaded,
        semester: widget.semester,
        education: widget.education,
        discipline: widget.discipline
      );
      return EndlessScrollingLoadChunkEvent<LoadDisciplineDiscussionListCommand>(command: command);
    }

  Widget build(BuildContext context) {
    return EndlessScrollingWidget<DiscussionMessage, LoadDisciplineDiscussionListCommand>(
      bloc: _bloc, 
      getLoadCommand: getLoadCommand,
      buildList: (ListedResponse<DiscussionMessage> dataList, [Function loadMoreList]) {
        ScrollController scrollController = ScrollController();
        final int scrollDistance = 200;

        scrollController.addListener(() {
          final maxScroll = scrollController.position.maxScrollExtent;
          final currentScroll = scrollController.position.pixels;
          if(loadMoreList != null && maxScroll - currentScroll <= scrollDistance) {
            loadMoreList();
          }
        });

        return ListView.builder(
          itemCount: dataList.payload.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) {
            if(index >= dataList.payload.length) 
            {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator()
                ],
              );
            }

            DiscussionMessage msg = dataList.payload[index];

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: MessageBubbleWidget(
                messageText: msg.msg,
                messageAttachment: (msg.attachments != null && msg.attachments.length != 0) ? msg.attachments[0]: null,
                messageExternalLink: (msg.externalLinks != null && msg.externalLinks.length != 0) ? msg.externalLinks[0]: null,
                sentByMe: msg.sender.id == widget.loggedPerson.id,
                sentTime: msg.created,
              )
            );
          }
        );
      },
    );
  }
}