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
import 'package:lk_client/store/local/messenger_page_provider.dart';
import 'package:lk_client/store/local/person_finder_page_provider.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';
import 'package:lk_client/widget/list/endless_scrolling_widget.dart';

class PersonList extends StatefulWidget
{
  PersonList({Key key}): super(key: key);

  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<StatefulWidget> {
  PersonListBloc _personListBloc;
  DialogCreatorBloc _dialogCreatorBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._personListBloc == null) {
      this._personListBloc = PersonFinderPageProvider.of(context).personListBloc;
      this._dialogCreatorBloc = PersonFinderPageProvider.of(context).dialogCreatorBloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Инициализация заполнения списка
    this._personListBloc.eventController.add(
      EndlessScrollingLoadEvent(
        command: LoadPersonListByTextQuery(
          count: 20, 
          offset: 0
        )
      )
    );

    ScrollController scrollController = ScrollController();
    final int scrollDistance = 200;

    EndlessScrollingLoadNextChunkEvent<LoadPersonListByTextQuery> nextChunkQueryEvent;
    bool needsAutoloading = false;

    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      if(needsAutoloading && nextChunkQueryEvent != null && maxScroll - currentScroll <= scrollDistance) {
        this._personListBloc.eventController.sink.add(nextChunkQueryEvent);
      }
    });

    return EndlessScrollingWidget<Person, LoadPersonListByTextQuery>(
      bloc: this._personListBloc,
      buildList: (EndlessScrollingState<Person> state) {
        if(state is EndlessScrollingChunkReadyState) {
          needsAutoloading = true;
          nextChunkQueryEvent = EndlessScrollingLoadNextChunkEvent<LoadPersonListByTextQuery>(
            command: (state as EndlessScrollingChunkReadyState).nextChunkCommand);
        } else {
          needsAutoloading = false;
        }

        if(state.entityList.length == 0) {
          if(state is EndlessScrollingErrorState){
            return Center(child: Text('Ошибка загрузки списка пользователей'));
          }

          if(state is EndlessScrollingLoadingState) {
            return CenteredLoader();
          }

          return Center(child: Text('Ничего не найдено'));
        }

        final dataList = state.entityList;
        return ListView.builder(
          itemCount: (state is EndlessScrollingChunkReadyState || state is EndlessScrollingLoadingState) ? dataList.length + 1 : dataList.length,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) {
            if(index >= dataList.length) {
              return ListLoadingBottomIndicator();
            }

            return Container(
              child: ListTile(
                //leading: PersonProfilePicture(displayed: dataList[index], size: 30.0),
                title: Text("${dataList[index].name} ${dataList[index].surname}"),
                onTap: () async {
                  this._dialogCreatorBloc.eventController.add(ProduceResourceEvent<void, StartNewDialog>(command: StartNewDialog(companion: dataList[index])));

                  await for (ProducingState<void> response in this._dialogCreatorBloc.dialogCreatorStateStream) {
                    if(response is ProducingErrorState<void>) {
                      throw response;
                    }
                    if(response is ProducingReadyState<void, DialogModel.Dialog>) {
                      DialogModel.Dialog createdDialog = response.response;
                      this._dialogCreatorBloc.eventController.add(ProducerInitEvent<void>());
                      MessengerPageProvider.of(context).dialogListBloc.eventController.add(
                        EndlessScrollingLoadEvent<LoadDialogListCommand>(command: LoadDialogListCommand(count: 50, offset: 0)));
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return PrivateDialogPage(
                            companion: dataList[index],
                            dialog: createdDialog,
                          );
                        })
                      );
                    }
                  }
                },
              ),
            );

          }
        );
      }
    );
  }
}