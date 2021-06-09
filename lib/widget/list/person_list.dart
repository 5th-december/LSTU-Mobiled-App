import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/dialog_creator_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/person_list_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/private_dialog_page.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';
import 'package:lk_client/state/producing_state.dart';
import 'package:lk_client/store/local/person_finder_page_provider.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';
import 'package:lk_client/widget/layout/profile_picture.dart';
import 'package:lk_client/widget/util/wait_modal_widget.dart';

class PersonList extends StatefulWidget {
  final Person person;

  PersonList({Key key, @required this.person}) : super(key: key);

  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  PersonListBloc _personListBloc;
  DialogCreatorBloc _dialogCreatorBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._personListBloc == null) {
      this._personListBloc =
          PersonFinderPageProvider.of(context).personListBloc;
      this
          ._personListBloc
          .eventController
          .add(EndlessScrollingInitEvent<Person>());
      this._dialogCreatorBloc =
          PersonFinderPageProvider.of(context).dialogCreatorBloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Инициализация заполнения списка
    this
        ._personListBloc
        .eventController
        .add(EndlessScrollingInitEvent<Person>());

    ScrollController scrollController = ScrollController();

    bool needsAutoloading = false;

    return StreamBuilder(
        stream: this._personListBloc.endlessListScrollingStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final state = snapshot.data;

            if (state is EndlessScrollingInitState) {
              scrollController.addListener(() {
                final maxScroll = scrollController.position.maxScrollExtent;
                final currentScroll = scrollController.position.pixels;
                if (needsAutoloading && maxScroll - currentScroll <= 200) {
                  this._personListBloc.eventController.sink.add(
                      LoadNextChunkEvent<LoadPersonListByTextQuery>(
                          command:
                              LoadPersonListByTextQuery(count: 50, offset: 0)));
                }
              });

              this._personListBloc.eventController.sink.add(
                  LoadFirstChunkEvent<LoadPersonListByTextQuery>(
                      command:
                          LoadPersonListByTextQuery(count: 50, offset: 0)));
            }

            if (state is EndlessScrollingChunkReadyState) {
              needsAutoloading = state.hasMoreData;
            } else {
              needsAutoloading = false;
            }

            if (state.entityList.length == 0) {
              if (state is EndlessScrollingErrorState) {
                return Center(
                    child: Text('Ошибка загрузки списка пользователей'));
              }

              if (state is EndlessScrollingLoadingState) {
                return CenteredLoader();
              }

              return Center(child: Text('Ничего не найдено'));
            }

            final dataList = state.entityList;
            return ListView.separated(
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                      height: 5.0,
                    ),
                itemCount: ((state is EndlessScrollingChunkReadyState &&
                            state.remains != 0) ||
                        state is EndlessScrollingLoadingState)
                    ? dataList.length + 1
                    : dataList.length,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= dataList.length) {
                    return ListLoadingBottomIndicator();
                  }

                  return Container(
                    child: ListTile(
                        leading: PersonProfilePicture(
                            displayed: dataList[index], size: 30),
                        title: Text(
                            "${dataList[index].name} ${dataList[index].surname}"),
                        trailing: IconButton(
                            icon: Icon(Icons.chat_bubble_rounded),
                            onPressed: () async {
                              this._dialogCreatorBloc.eventController.add(
                                  ProduceResourceEvent<void, StartNewDialog>(
                                      command: StartNewDialog(
                                          companion: dataList[index])));

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                useRootNavigator: false,
                                builder: (BuildContext context) {
                                  return WaitModalWidget();
                                },
                              );

                              Completer<DialogModel.Dialog> completer =
                                  Completer<DialogModel.Dialog>();

                              completer.future.then((value) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return PrivateDialogPage(
                                    person: widget.person,
                                    companion: dataList[index],
                                    dialog: value,
                                  );
                                }));
                              }, onError: (e) {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    useRootNavigator: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Text('Ошибка'),
                                          content:
                                              Text('Не удалось открыть диалог'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('ОК'))
                                          ]);
                                    });
                              });

                              Future.delayed(Duration.zero, () async {
                                await for (ProducingState<void> response in this
                                    ._dialogCreatorBloc
                                    .dialogCreatorStateStream) {
                                  if (response is ProducingErrorState<void>) {
                                    completer.completeError(response.error);
                                  }
                                  if (response is ProducingReadyState<void,
                                      DialogModel.Dialog>) {
                                    DialogModel.Dialog createdDialog =
                                        response.response;

                                    completer.complete(createdDialog);

                                    this
                                        ._dialogCreatorBloc
                                        .eventController
                                        .add(ProducerInitEvent<void>());
                                  }
                                }
                              });
                            })),
                  );
                });
          }

          return CenteredLoader();
        });
  }
}
