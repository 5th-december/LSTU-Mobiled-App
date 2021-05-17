import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/dialog_list_bloc.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/private_dialog_page.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/local/messenger_page_provider.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';
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
      this._bloc = MessengerPageProvider.of(context).dialogListBloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Инициализация заполнения списка
    this._bloc.eventController.sink.add(
      EndlessScrollingLoadEvent<LoadDialogListCommand>(
        command: LoadDialogListCommand(count: 50, offset: 0)
      )
    );

    final ScrollController scrollController = ScrollController();
    final int scrollDistance = 200;

    EndlessScrollingLoadNextChunkEvent<LoadDialogListCommand> nextChunkQueryEvent;
    bool needsAutoloading = false;

    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      if (needsAutoloading && nextChunkQueryEvent != null && maxScroll - currentScroll <= scrollDistance) {
        this._bloc.eventController.sink.add(nextChunkQueryEvent);
      }
    });

    return EndlessScrollingWidget<DialogModel.Dialog, LoadDialogListCommand>(
      bloc: this._bloc,
      buildList: (EndlessScrollingState<DialogModel.Dialog> state) {

        if(state is EndlessScrollingChunkReadyState) {
          needsAutoloading = true;
          nextChunkQueryEvent = EndlessScrollingLoadNextChunkEvent<LoadDialogListCommand>(
            command: (state as EndlessScrollingChunkReadyState).nextChunkCommand);
        } else {
          needsAutoloading = false;
        }

        if(state.entityList.length == 0) {
          if(state is EndlessScrollingLoadingState) {
            return CenteredLoader();
          }

          if(state is EndlessScrollingErrorState) {
            return Center(child: Text('Ошибка загрузки диалогов'));
          }

          return Center(child: Text('Ничего не найдено'));
        }
        
        List<DialogModel.Dialog> loadedDialogs = state.entityList;

        return ListView.builder(
          itemCount: (state is EndlessScrollingChunkReadyState || state is EndlessScrollingLoadingState) ? loadedDialogs.length + 1 : loadedDialogs.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) {
            if(index >= loadedDialogs.length) {
              return ListLoadingBottomIndicator();
            }

            Person companion = loadedDialogs[index].companion;
            PrivateMessage lastDialogMessage = loadedDialogs[index].lastMessage;
            String displayedMessageText = lastDialogMessage?.messageText ?? '';

            return Container(
              child: ListTile(
                //leading: PersonProfilePicture(displayed: companion, size: 30,),
                title: Text("${companion.name} ${companion.surname}"),
                subtitle: Text("$displayedMessageText"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return PrivateDialogPage(
                          companion: companion,
                          dialog: loadedDialogs[index]
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