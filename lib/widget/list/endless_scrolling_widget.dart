import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/infinite_scrollers/abstract_endless_scrolling_bloc.dart';
import 'package:lk_client/state/endless_scrolling_state.dart';

class EndlessScrollingWidget<T, C> extends StatefulWidget {
  final AbstractEndlessScrollingBloc<T, C> bloc;

  final Function buildList;

  EndlessScrollingWidget({Key key, this.buildList, this.bloc})
      : super(key: key);

  @override
  _EndlessScrollingWidgetState createState() => _EndlessScrollingWidgetState();
}

class _EndlessScrollingWidgetState<T, C>
    extends State<EndlessScrollingWidget<T, C>> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.bloc.endlessListScrollingStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return this
                .widget
                .buildList(snapshot.data as EndlessScrollingState<T>);
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
