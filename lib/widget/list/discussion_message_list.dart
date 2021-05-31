import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/infinite_scrollers/discussion_list_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';
import 'package:lk_client/widget/chunk/message_bubble_widget.dart';
import 'package:lk_client/widget/list/endless_scrolling_widget.dart';

class DiscussionMessageList extends StatefulWidget {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  final Person loggedPerson;

  DiscussionMessageList(
      {Key key,
      @required this.discipline,
      @required this.education,
      @required this.semester,
      @required this.loggedPerson})
      : super(key: key);

  @override
  _DiscussionMessageList createState() => _DiscussionMessageList();
}

class _DiscussionMessageList extends State<DiscussionMessageList> {
  DiscussionListBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      MessengerQueryService messengerQueryService =
          AppStateContainer.of(context).serviceProvider.messengerQueryService;
      DiscussionLoadingBloc discussionLoadingBloc =
          DiscussionLoadingBloc(messengerQueryService);
      this._bloc = DiscussionListBloc(discussionLoadingBloc);
    }
  }

  Widget build(BuildContext context) {
    final loadCommand =
        EndlessScrollingLoadEvent<LoadDisciplineDiscussionListCommand>(
            command: LoadDisciplineDiscussionListCommand(
                count: 50,
                offset: 0,
                discipline: widget.discipline,
                education: widget.education,
                semester: widget.semester));

    this._bloc.eventController.sink.add(loadCommand);

    ScrollController scrollController = ScrollController();
    final int scrollDistance = 200;

    bool needsAutoloading = false;

    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      if (needsAutoloading && maxScroll - currentScroll <= scrollDistance) {
        this._bloc.eventController.sink.add(loadCommand);
      }
    });

    return EndlessScrollingWidget<DiscussionMessage,
        LoadDisciplineDiscussionListCommand>(
      bloc: _bloc,
      buildList: (EndlessScrollingState<DiscussionMessage> state) {
        if (state is EndlessScrollingChunkReadyState) {
          needsAutoloading =
              (state as EndlessScrollingChunkReadyState).hasMoreData;
        } else {
          needsAutoloading = false;
        }

        if (state.entityList.length == 0) {
          if (state is EndlessScrollingLoadingState) {
            return CenteredLoader();
          }

          if (state is EndlessScrollingErrorState) {
            return Center(child: Text('Ошибка загрузки обсуждений'));
          }

          return Center(child: Text('Нет сообщений'));
        }

        List<DiscussionMessage> loadedMessages = state.entityList;

        return ListView.builder(
            itemCount: (state is EndlessScrollingChunkReadyState ||
                    state is EndlessScrollingLoadingState)
                ? loadedMessages.length + 1
                : loadedMessages.length,
            reverse: true,
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) {
              if (index >= loadedMessages.length) {
                return ListLoadingBottomIndicator();
              }

              DiscussionMessage msg = loadedMessages[index];

              return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: MessageBubbleWidget(
                    messageText: msg.msg,
                    messageAttachment:
                        (msg.attachments != null && msg.attachments.length != 0)
                            ? msg.attachments[0]
                            : null,
                    messageExternalLink: (msg.externalLinks != null &&
                            msg.externalLinks.length != 0)
                        ? msg.externalLinks[0]
                        : null,
                    sentByMe: msg.sender.id == widget.loggedPerson.id,
                    sentTime: msg.created,
                    sender: msg.sender,
                  ));
            });
      },
    );
  }
}
