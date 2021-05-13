import 'package:flutter/cupertino.dart';
import 'package:lk_client/bloc/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/page/basic/fullscreen_loading_page.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';

class EndlessScrollingWidget<T, C> extends StatefulWidget {
  final AbstractEndlessScrollingBloc<T, dynamic> bloc;

  final Function getLoadCommand;

  final Function buildList;

  EndlessScrollingWidget({Key key, this.getLoadCommand, this.buildList, this.bloc}): super(key: key);

  @override
  _EndlessScrollingWidgetState createState() => _EndlessScrollingWidgetState();
}

class _EndlessScrollingWidgetState<T, C> extends State<EndlessScrollingWidget<T,C>> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.bloc.endlessListScrollingStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          final state = snapshot.data as EndlessScrollingState<T>;

          if(state is EndlessScrollingErrorState<T>) {
            widget.bloc.eventController.sink.add(widget.getLoadCommand(state.entityList));
          } else if (state is EndlessScrollingChunkReadyState<T>) {
            final currentData = state.entityList;
            return widget.buildList(currentData, () {
              this.widget.bloc.eventController.sink.add(widget.getLoadCommand(currentData));
            });
          } else if (state is EndlessScrollingNoMoreDataState<T>) {
            return this.widget.buildList(state.entityList);
          }
        }

        return FullscreenLoadingPage();
      }
    );
  }
}