import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/proxy/private_message_list_proxy_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/event/proxy_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
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

class PrivateMessageList extends StatefulWidget {
  final DialogModel.Dialog dialog;
  final Person person;
  final Future<PrivateMessageListProxyBloc> privateMessageListProxyBloc;

  PrivateMessageList(
      {Key key,
      @required this.dialog,
      @required this.person,
      @required this.privateMessageListProxyBloc})
      : super(key: key);

  @override
  _PrivateMessageListState createState() => _PrivateMessageListState();
}

class _PrivateMessageListState extends State<PrivateMessageList> {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.privateMessageListProxyBloc,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text('Произошла непредвиденная ошибка'));
            } else {
              PrivateMessageListProxyBloc bloc = snapshot.data;

              bloc.eventController.sink.add(
                  ProxyInitEvent<StartNotifyPrivateMessagesOnDialog>(
                      command: StartNotifyPrivateMessagesOnDialog(
                          trackedDialog: widget.dialog,
                          trackedPerson: widget.person)));

              final listViewScrollController = ScrollController();

              bool needsAutoloading = false;

              return StreamBuilder(
                stream: bloc.privateMessageListStateStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final state = snapshot.data;

                    if (state is EndlessScrollingInitState) {
                      listViewScrollController.addListener(() {
                        final maxScroll =
                            listViewScrollController.position.maxScrollExtent;
                        final currentScroll =
                            listViewScrollController.position.pixels;
                        if (needsAutoloading &&
                            maxScroll - currentScroll <= 200.0) {
                          bloc.eventController.sink.add(LoadNextChunkEvent<
                                  LoadPrivateChatMessagesListCommand>(
                              command: LoadPrivateChatMessagesListCommand(
                                  dialog: widget.dialog, count: 50)));
                        }
                      });

                      bloc.eventController.sink.add(LoadFirstChunkEvent<
                              LoadPrivateChatMessagesListCommand>(
                          command: LoadPrivateChatMessagesListCommand(
                              dialog: widget.dialog, count: 50)));
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
                            child: Text('Ошибка загрузки истории сообщений'));
                      }

                      return Center(child: Text('История сообщений пуста'));
                    }

                    List<PrivateMessage> messageList = state.entityList;

                    return ListView.builder(
                        controller: listViewScrollController,
                        reverse: true,
                        itemCount: ((state is EndlessScrollingChunkReadyState &&
                                    state.hasMoreData) ||
                                state is EndlessScrollingLoadingState)
                            ? messageList.length + 1
                            : messageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= messageList.length) {
                            return ListLoadingBottomIndicator();
                          }

                          PrivateMessage msg = messageList[index];

                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: MessageBubbleWidget(
                              messageText: msg.messageText,
                              attachmentWidget: () {
                                if (msg.attachments != null &&
                                    msg.attachments.length != 0) {
                                  return FileDownloadWidget(
                                    fileMaterial: DownloadFileMaterial(
                                        originalFileName:
                                            msg.attachments[0].attachmentName,
                                        attachmentId: msg.id,
                                        attachment: msg.attachments[0],
                                        command:
                                            LoadPrivateMessageMaterialAttachment(
                                                privateMessage: msg)),
                                    proxyBloc:
                                        PrivateMessageDownloaderProxyBloc(
                                            fileDownloaderBlocProvider: this
                                                ._fileDownloaderBlocProvider,
                                            fileLocalManager:
                                                this._fileLocalManager,
                                            fileTransferService:
                                                this._fileTransferService,
                                            appNotifier: this._appNotifier),
                                  );
                                } else if (msg.links != null &&
                                    msg.links.length != 0) {
                                  return LinkOpenWidget(
                                      externalLink:
                                          DownloadExternalLinkMaterial(
                                              externalLink: ExternalLink(
                                                  linkContent:
                                                      msg.links[0].linkContent,
                                                  linkText:
                                                      msg.links[0].linkText)));
                                }
                              }(),
                              sentByMe: msg.meSender ?? false,
                              sentTime: msg.sendTime,
                              isRead: msg.isRead ?? true,
                            ),
                          );
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
      },
    );
  }
}
