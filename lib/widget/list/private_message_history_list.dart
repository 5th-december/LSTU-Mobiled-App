import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/bloc/private_message_history_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/message_bubble_widget.dart';
import 'package:lk_client/widget/list/endless_scrolling_widget.dart';

class PrivateMessageHistoryList extends StatefulWidget {
  final DialogModel.Dialog dialog;

  PrivateMessageHistoryList({Key key, @required this.dialog}): super(key: key);

  @override
  _PrivateMessageHistoryListState createState() =>_PrivateMessageHistoryListState();
}

class _PrivateMessageHistoryListState extends State<PrivateMessageHistoryList> {
  PrivateMessageHistoryBloc _bloc;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(this._bloc == null) {
      MessengerQueryService messengerQueryService = 
        AppStateContainer.of(context).serviceProvider.messengerQueryService;
      PrivateChatMessagesListLoadingBloc privateChatMessagesListLoadingBloc = 
        PrivateChatMessagesListLoadingBloc(messengerQueryService);
      this._bloc = PrivateMessageHistoryBloc(privateChatMessagesListLoadingBloc);
    }
  }

  EndlessScrollingLoadChunkEvent<LoadPrivateChatMessagesListCommand> getLoadCommand([ListedResponse<PrivateMessage> currentState]) {
    int lastLoaded = currentState?.nextOffset ?? 0;
    final command = LoadPrivateChatMessagesListCommand(widget.dialog, 50, lastLoaded);
    return EndlessScrollingLoadChunkEvent<LoadPrivateChatMessagesListCommand>(command: command);
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(this.getLoadCommand());

    return EndlessScrollingWidget<PrivateMessage, LoadPrivateChatMessagesListCommand>(
      bloc: this._bloc,
      getLoadCommand: getLoadCommand,
      buildList: (ListedResponse<PrivateMessage> dataList, [Function loadMoreList]) {
        final listViewScrollController = ScrollController();
        final scrollDistance = 200.0;

        listViewScrollController.addListener(() {
          final maxScroll = listViewScrollController.position.maxScrollExtent;
          final currentScroll = listViewScrollController.position.pixels;
          if (loadMoreList != null && maxScroll - currentScroll <= scrollDistance) {
            loadMoreList();
          }
        });

        return ListView.builder(
          controller: listViewScrollController,
          itemCount: loadMoreList == null ? dataList.payload.length: dataList.payload.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if(index >= dataList.payload.length) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator()
                ],
              );
            }

            PrivateMessage msg = dataList.payload[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: MessageBubbleWidget(
                messageText: msg.messageText,
                messageAttachment: (msg.attachments != null && msg.attachments.length != 0) ? msg.attachments[0] : null,
                messageExternalLink: (msg.links != null && msg.links.length != 0) ? msg.links[0] : null,
                sentByMe: msg.meSender ?? false,
                sentTime: msg.sendTime,
              ),
            );
          }
        );
      },
    );
  }
}