import 'package:flutter/widgets.dart';

abstract class EndlessScrollingState<T> {
  final List<T> entityList;
  EndlessScrollingState({this.entityList = const []});
}

class EndlessScrollingInitState<T> extends EndlessScrollingState<T> {
  EndlessScrollingInitState({List<T> entityList = const []})
      : super(entityList: entityList);
}

class EndlessScrollingLoadingState<C, T> extends EndlessScrollingState<T> {
  final C previousCommand;
  EndlessScrollingLoadingState(
      {List<T> entityList = const [], @required this.previousCommand})
      : super(entityList: entityList);
}

class EndlessScrollingErrorState<C, T> extends EndlessScrollingState<T> {
  final Exception error;
  final C previousCommand;
  EndlessScrollingErrorState(
      {@required this.error,
      List<T> entityList = const [],
      @required this.previousCommand})
      : super(entityList: entityList);
}

class EndlessScrollingChunkReadyState<C, T> extends EndlessScrollingState<T> {
  bool hasMoreData;
  int remains;
  C previousCommand;
  EndlessScrollingChunkReadyState(
      {@required List<T> entityList,
      @required this.hasMoreData,
      @required this.remains,
      @required this.previousCommand})
      : super(entityList: entityList);
}
