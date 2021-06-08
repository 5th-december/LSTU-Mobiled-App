import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/proxy/discussion_message_list_proxy_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/notification/notifier.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/loader_provider.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';
import 'package:lk_client/widget/chunk/file_download_widget.dart';
import 'package:lk_client/widget/chunk/link_open_widget.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';
import 'package:lk_client/widget/chunk/message_bubble_widget.dart';

class DiscussionMessageList extends StatefulWidget {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  final Person loggedPerson;
  final Future<DiscussionMessageListProxyBloc> discussionMessageListProxyBloc;

  DiscussionMessageList(
      {Key key,
      @required this.discipline,
      @required this.education,
      @required this.semester,
      @required this.loggedPerson,
      @required this.discussionMessageListProxyBloc})
      : super(key: key);

  @override
  _DiscussionMessageList createState() => _DiscussionMessageList();
}

class _DiscussionMessageList extends State<DiscussionMessageList> {
  Notifier _appNotifier;
  FileTransferService _fileTransferService;
  FileLocalManager _fileLocalManager;
  FileDownloaderBlocProvider _fileDownloaderBlocProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ServiceProvider serviceProvider =
        AppStateContainer.of(context).serviceProvider;

    if (this._fileLocalManager == null) {
      this._fileLocalManager = serviceProvider.fileLocalManager;
    }

    if (this._appNotifier == null) {
      this._appNotifier = serviceProvider.notifier;
    }

    if (this._fileTransferService == null) {
      this._fileTransferService = serviceProvider.fileTransferService;
    }

    if (this._fileDownloaderBlocProvider == null) {
      this._fileDownloaderBlocProvider =
          LoaderProvider.of(context).fileDownloaderBlocProvider;
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.discussionMessageListProxyBloc,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Произошла ошибка'));
              } else {
                final bloc = snapshot.data;

                bloc.eventController.sink.add(
                    EndlessScrollingLoadEvent<StartNotifyOnDiscussion>(
                        command: StartNotifyOnDiscussion(
                            discipline: widget.discipline.id,
                            semester: widget.semester.id,
                            group: widget.education.group.id)));

                ScrollController scrollController = ScrollController();

                bool needsAutoloading = false;

                scrollController.addListener(() {});

                return StreamBuilder(
                  stream: bloc.discussionMessageListStateStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final state = snapshot.data;

                      if (state is EndlessScrollingInitState) {
                        final loadNextChunkEvent = EndlessScrollingLoadEvent<
                                LoadDisciplineDiscussionListCommand>(
                            command: LoadDisciplineDiscussionListCommand(
                                semester: widget.semester,
                                education: widget.education,
                                discipline: widget.discipline,
                                count: 50));

                        scrollController.addListener(() {
                          final maxScroll =
                              scrollController.position.maxScrollExtent;
                          final currentScroll =
                              scrollController.position.pixels;
                          if (needsAutoloading &&
                              maxScroll - currentScroll <= 200.0) {
                            bloc.eventController.sink.add(loadNextChunkEvent);
                          }
                        });

                        bloc.eventController.sink.add(loadNextChunkEvent);
                      }

                      if (state is EndlessScrollingChunkReadyState) {
                        needsAutoloading = state.hasMoreData;
                      } else {
                        needsAutoloading = false;
                      }

                      if (state.entityList.length == 0) {
                        if (state is EndlessScrollingLoadingState) {
                          return CenteredLoader();
                        }

                        if (state is EndlessScrollingErrorState) {
                          return Center(
                              child: Text('Ошибка загрузки обсуждений'));
                        }

                        return Center(child: Text('Нет сообщений'));
                      }

                      List<DiscussionMessage> loadedMessages = state.entityList;

                      return ListView.builder(
                          itemCount:
                              (state is EndlessScrollingChunkReadyState ||
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Align(
                                    alignment:
                                        msg.sender.id == widget.loggedPerson.id
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: MessageBubbleWidget(
                                      messageText: msg.msg,
                                      sender: msg.sender,
                                      attachmentWidget: () {
                                        if (msg.attachments != null &&
                                            msg.attachments.length != 0) {
                                          return FileDownloadWidget(
                                            fileMaterial: DownloadFileMaterial(
                                                originalFileName: msg
                                                    .attachments[0]
                                                    .attachmentName,
                                                attachmentId: msg.id,
                                                attachment: msg.attachments[0],
                                                command:
                                                    LoadDiscussionMessageMaterialAttachment(
                                                        discussionMessage:
                                                            msg)),
                                            proxyBloc: DiscussionMessageDownloaderProxyBloc(
                                                fileDownloaderBlocProvider: this
                                                    ._fileDownloaderBlocProvider,
                                                fileLocalManager:
                                                    this._fileLocalManager,
                                                fileTransferService:
                                                    this._fileTransferService,
                                                appNotifier: this._appNotifier),
                                          );
                                        } else if (msg.externalLinks != null &&
                                            msg.externalLinks.length != 0) {
                                          return LinkOpenWidget(
                                              externalLink:
                                                  DownloadExternalLinkMaterial(
                                                      externalLink: ExternalLink(
                                                          linkContent: msg
                                                              .externalLinks[0]
                                                              .linkContent,
                                                          linkText: msg
                                                              .externalLinks[0]
                                                              .linkText)));
                                        }
                                      }(),
                                      sentByMe: msg.sender.id ==
                                          widget.loggedPerson.id,
                                      sentTime: msg.created ?? true,
                                      isRead: true,
                                    )));
                          });
                    }

                    return CenteredLoader();
                  },
                );
              }
              break;
            default:
              return CenteredLoader();
          }
        });
  }
}
