import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/proxy/private_message_list_proxy_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';
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
                  EndlessScrollingLoadEvent<StartNotifyPrivateMessagesOnDialog>(
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
                      final loadNextChunkEvent = EndlessScrollingLoadEvent<
                              LoadPrivateChatMessagesListCommand>(
                          command: LoadPrivateChatMessagesListCommand(
                              dialog: widget.dialog, count: 50));

                      listViewScrollController.addListener(() {
                        final maxScroll =
                            listViewScrollController.position.maxScrollExtent;
                        final currentScroll =
                            listViewScrollController.position.pixels;
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
                            child: Text('Ошибка загрузки истории сообщений'));
                      }

                      return Center(child: Text('История сообщений пуста'));
                    }

                    List<PrivateMessage> messageList = state.entityList;

                    return ListView.builder(
                        controller: listViewScrollController,
                        reverse: true,
                        itemCount: ((state is EndlessScrollingChunkReadyState &&
                                    (state as EndlessScrollingChunkReadyState<
                                            PrivateMessage>)
                                        .hasMoreData) ||
                                state is EndlessScrollingLoadingState)
                            ? messageList.length + 1
                            : messageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= messageList.length) {
                            ListLoadingBottomIndicator();
                          }

                          PrivateMessage msg = messageList[index];

                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: MessageBubbleWidget(
                              messageText: msg.messageText,
                              messageAttachment: (msg.attachments != null &&
                                      msg.attachments.length != 0)
                                  ? msg.attachments[0]
                                  : null,
                              messageExternalLink:
                                  (msg.links != null && msg.links.length != 0)
                                      ? msg.links[0]
                                      : null,
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
