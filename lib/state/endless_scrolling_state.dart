import 'package:flutter/widgets.dart';

abstract class EndlessScrollingState<T> {
  final List<T> entityList;
  EndlessScrollingState({@required this.entityList});
}

class EndlessScrollingInitState<T> extends EndlessScrollingState<T> {
  EndlessScrollingInitState({List<T> entityList = const []})
      : super(entityList: entityList);
}

class EndlessScrollingLoadingState<T> extends EndlessScrollingState<T> {
  EndlessScrollingLoadingState({List<T> entityList = const []})
      : super(entityList: entityList);
}

class EndlessScrollingErrorState<T> extends EndlessScrollingState<T> {
  final Exception error;
  EndlessScrollingErrorState(
      {@required this.error, List<T> entityList = const []})
      : super(entityList: entityList);
}

class EndlessScrollingChunkReadyState<T> extends EndlessScrollingState<T> {
  bool hasMoreData;
  int remains;
  EndlessScrollingChunkReadyState(
      {@required List<T> entityList,
      @required this.hasMoreData,
      @required this.remains})
      : super(entityList: entityList);
}
