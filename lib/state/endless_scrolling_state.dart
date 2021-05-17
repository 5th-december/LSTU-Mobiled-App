import 'package:flutter/widgets.dart';

abstract class EndlessScrollingState<T> {
  final List<T> entityList;
  EndlessScrollingState({@required this.entityList});
}

class EndlessScrollingInitState<T> extends EndlessScrollingState<T> {
  EndlessScrollingInitState({List<T> entityList = const[]}): super(entityList: entityList);
}

class EndlessScrollingLoadingState<T> extends EndlessScrollingState<T> {
  EndlessScrollingLoadingState({List<T> entityList = const[]}): super(entityList: entityList);
}

class EndlessScrollingErrorState<T> extends EndlessScrollingState<T>{
  final Exception error;
  EndlessScrollingErrorState({List<T> entityList = const[], @required this.error}): super(entityList: entityList);
}

class EndlessScrollingChunkReadyState<T, C> extends EndlessScrollingState<T>{
  C nextChunkCommand;
  EndlessScrollingChunkReadyState({@required List<T> entityList, this.nextChunkCommand}): super(entityList: entityList);
}

class EndlessScrollingNoMoreDataState<T> extends EndlessScrollingState<T> {
  EndlessScrollingNoMoreDataState({@required List<T> entityList}): super(entityList: entityList);
}