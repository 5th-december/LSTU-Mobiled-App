import 'package:flutter/widgets.dart';
import 'package:lk_client/model/listed_response.dart';

abstract class EndlessScrollingState<T> {
  final ListedResponse<T> entityList;
  EndlessScrollingState({@required this.entityList});
}

class EndlessScrollingInitState<T> extends EndlessScrollingState<T> {
  EndlessScrollingInitState({@required ListedResponse<T> entityList}): super(entityList: entityList);
}

class EndlessScrollingLoadingState<T> extends EndlessScrollingState<T> {
  EndlessScrollingLoadingState({@required ListedResponse<T> entityList}): super(entityList: entityList);
}

class EndlessScrollingErrorState<T> extends EndlessScrollingState<T> {
  EndlessScrollingErrorState({@required ListedResponse<T> entityList}): super(entityList: entityList);
}

class EndlessScrollingChunkReadyState<T> extends EndlessScrollingState<T> {
  EndlessScrollingChunkReadyState({@required ListedResponse<T> entityList}): super(entityList: entityList);
}

class EndlessScrollingNoMoreDataState<T> extends EndlessScrollingState<T> {
  EndlessScrollingNoMoreDataState({@required ListedResponse<T> entityList}): super(entityList: entityList);
}