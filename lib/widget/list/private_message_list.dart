import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/infinite_scrollers/private_message_list_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';
import 'package:lk_client/store/local/private_dialog_page_provider.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';
import 'package:lk_client/widget/chunk/message_bubble_widget.dart';
import 'package:lk_client/widget/list/endless_scrolling_widget.dart';

class PrivateMessageHistoryList extends StatefulWidget {
  final DialogModel.Dialog dialog;

  PrivateMessageHistoryList({Key key, @required this.dialog}) : super(key: key);

  @override
  _PrivateMessageHistoryListState createState() =>
      _PrivateMessageHistoryListState();
}

class _PrivateMessageHistoryListState extends State<PrivateMessageHistoryList> {
  PrivateMessageListBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      this._bloc = PrivateDialogPageProvider.of(context).privateMessageListBloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadingEvent =
        EndlessScrollingLoadEvent<LoadPrivateChatMessagesListCommand>(
            command: LoadPrivateChatMessagesListCommand(
                count: 50, offset: 0, dialog: widget.dialog));
    this._bloc.eventController.sink.add(loadingEvent);

    final listViewScrollController = ScrollController();
    final scrollDistance = 200.0;

    bool needsAutoloading = false;

    listViewScrollController.addListener(() {
      final maxScroll = listViewScrollController.position.maxScrollExtent;
      final currentScroll = listViewScrollController.position.pixels;
      if (needsAutoloading && maxScroll - currentScroll <= scrollDistance) {
        this._bloc.eventController.sink.add(loadingEvent);
      }
    });

    return EndlessScrollingWidget<PrivateMessage,
        LoadPrivateChatMessagesListCommand>(
      bloc: this._bloc,
      buildList: (EndlessScrollingState<PrivateMessage> state) {
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
            return Center(child: Text('Ошибка загрузки истории сообщений'));
          }

          return Center(child: Text('История сообщений пуста'));
        }

        List<PrivateMessage> messageList = state.entityList;

        return ListView.builder(
            controller: listViewScrollController,
            reverse: true,
            itemCount: (state is EndlessScrollingChunkReadyState ||
                    state is EndlessScrollingLoadingState)
                ? messageList.length + 1
                : messageList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index >= messageList.length) {
                ListLoadingBottomIndicator();
              }

              PrivateMessage msg = messageList[index];

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: MessageBubbleWidget(
                  messageText: msg.messageText,
                  messageAttachment:
                      (msg.attachments != null && msg.attachments.length != 0)
                          ? msg.attachments[0]
                          : null,
                  messageExternalLink:
                      (msg.links != null && msg.links.length != 0)
                          ? msg.links[0]
                          : null,
                  sentByMe: msg.meSender ?? false,
                  sentTime: msg.sendTime,
                ),
              );
            });
      },
    );
  }
}
