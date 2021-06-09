import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/proxy/dialog_list_proxy_bloc.dart';
import 'package:lk_client/bloc/widget/messenger_tile_bloc.dart';
import 'package:lk_client/bloc_container/mbc_chat_update_bloc_container.dart';
import 'package:lk_client/bloc_container/mbc_private_message_bloc_container.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/private_dialog_page.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';
import 'package:lk_client/store/global/mbc_bloc_provider.dart';
import 'package:lk_client/store/local/messenger_page_provider.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';
import 'package:lk_client/widget/chunk/dialog_tile_widget.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';

class DialogList extends StatefulWidget {
  final Person person;
  DialogList({Key key, @required this.person}) : super(key: key);

  @override
  _DialogListState createState() => _DialogListState();
}

class _DialogListState extends State<DialogList> {
  Future<DialogListProxyBloc> _dialogListProxyBloc;

  Future<MbCChatUpdateBlocContainer> _chatUpdateBlocContainer;

  Future<MbCPrivateMessageBlocContainer> _privateMessageBlocContainer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._dialogListProxyBloc == null) {
      this._dialogListProxyBloc =
          MessengerPageProvider.of(context).dialogListBloc;
    }

    if (this._chatUpdateBlocContainer == null) {
      this._chatUpdateBlocContainer =
          MbCBlocProvider.of(context).mbCChatUpdateBlocContainer();
    }

    if (this._privateMessageBlocContainer == null) {
      this._privateMessageBlocContainer =
          MbCBlocProvider.of(context).mbCPrivateMessageBlocContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this._dialogListProxyBloc,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Произошла непредвиденная ошибка'));
              } else {
                final bloc = snapshot.data;
                bloc.eventController.sink.add(
                    EndlessScrollingLoadEvent<StartNotifyOnPerson>(
                        command:
                            StartNotifyOnPerson(trackedPerson: widget.person)));

                final ScrollController scrollController = ScrollController();

                bool needsAutoloading = false;

                return StreamBuilder(
                  stream: bloc.dialogListStateStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final state = snapshot.data;

                      if (state is EndlessScrollingInitState) {
                        /**
             * Когда виджет инициализирован, на контроллер скролла вешается листенер
             * отправляющий новые команды для добавления строк
             * и отправляется команда
             */
                        scrollController.addListener(() {
                          final maxScroll =
                              scrollController.position.maxScrollExtent;
                          final currentScroll =
                              scrollController.position.pixels;
                          if (needsAutoloading &&
                              maxScroll - currentScroll <= 200) {
                            bloc.eventController.sink.add(
                                EndlessScrollingLoadEvent<
                                        LoadDialogListCommand>(
                                    command: LoadDialogListCommand(count: 50)));
                          }
                        });
                        bloc.eventController.sink.add(
                            EndlessScrollingLoadEvent<LoadDialogListCommand>(
                                command: LoadDialogListCommand(count: 50)));
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
                              child: Text('Ошибка загрузки диалогов'));
                        }

                        return Center(child: Text('Ничего не найдено'));
                      }

                      List<DialogModel.Dialog> loadedDialogs = state.entityList;

                      return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 10.0),
                          child: ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) => SizedBox(
                                        height: 8.0,
                                      ),
                              itemCount:
                                  ((state is EndlessScrollingChunkReadyState &&
                                              state.hasMoreData) ||
                                          state is EndlessScrollingLoadingState)
                                      ? loadedDialogs.length + 1
                                      : loadedDialogs.length,
                              controller: scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                if (index >= loadedDialogs.length) {
                                  return ListLoadingBottomIndicator();
                                }

                                Person companion =
                                    loadedDialogs[index].companion;
                                PrivateMessage lastDialogMessage =
                                    loadedDialogs[index].lastMessage;

                                return Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return PrivateDialogPage(
                                            companion: companion,
                                            person: widget.person,
                                            dialog: loadedDialogs[index]);
                                      }));
                                    },
                                    child: DialogTileWidget(
                                      dialog: loadedDialogs[index],
                                      person: companion,
                                      lastloadedMessage: lastDialogMessage,
                                      messengerTileBloc: MessengerTileBloc.init(
                                          dialog: loadedDialogs[index],
                                          person: companion,
                                          chatUpdateBlocContainer:
                                              this._chatUpdateBlocContainer,
                                          privateMessageBlocContainer: this
                                              ._privateMessageBlocContainer),
                                    ),
                                  ),
                                );
                              }));
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
