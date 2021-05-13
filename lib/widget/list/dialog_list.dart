import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/dialog_list_bloc.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/private_dialog_page.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/layout/profile_picture.dart';
import 'package:lk_client/widget/list/endless_scrolling_widget.dart';

class DialogList extends StatefulWidget {
  DialogList({Key key}): super(key: key);

  @override
  _DialogListState createState() => _DialogListState();
}

class _DialogListState extends State<DialogList> {
  DialogListBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._bloc == null) {
      MessengerQueryService messengerQueryService = 
        AppStateContainer.of(context).serviceProvider.messengerQueryService;
      DialogListLoadingBloc dialogListLoadingBloc = DialogListLoadingBloc(messengerQueryService);
      this._bloc = DialogListBloc(dialogListLoadingBloc);
    }
  }

  EndlessScrollingLoadChunkEvent<LoadDialogListCommand> getLoadCommand
    ([ListedResponse<DialogModel.Dialog> currentState]) {
    final int lastLoaded = currentState?.nextOffset ?? 0;
    LoadDialogListCommand command = LoadDialogListCommand(50, lastLoaded);
    return EndlessScrollingLoadChunkEvent<LoadDialogListCommand>(command: command);
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(getLoadCommand());

    return EndlessScrollingWidget<DialogModel.Dialog, LoadDialogListCommand>(
      bloc: this._bloc,
      getLoadCommand: this.getLoadCommand,
      buildList: (ListedResponse<DialogModel.Dialog> dataList, [Function loadMoreList]) {
        final ScrollController scrollController = ScrollController();
        final int scrollDistance = 200;

        scrollController.addListener(() {
          final maxScroll = scrollController.position.maxScrollExtent;
          final currentScroll = scrollController.position.pixels;
          if (loadMoreList != null && maxScroll - currentScroll <= scrollDistance) {
            loadMoreList();
          }
        });
        
        return ListView.builder(
          itemCount: dataList.payload.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) {
            if(index >= dataList.payload.length) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator()
                ],
              );
            }

            Person companion = dataList.payload[index].companion;
            PrivateMessage lastDialogMessage = dataList.payload[index].lastMessage;

            return Container(
              child: ListTile(
                leading: PersonProfilePicture(displayed: companion, size: 30,),
                title: Text("${companion.name} ${companion.surname}"),
                subtitle: Text("${lastDialogMessage.messageText}"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return PrivateDialogPage(
                          companion: companion,
                          dialog: dataList.payload[index],
                        );
                      } 
                    )
                  );
                },
              ),
            );
          }
        );
      },
    );
  }
}