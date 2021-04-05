abstract class ContentState<T> {}

class ContentInitState<T> extends ContentState<T> {}

class ContentLoadingState<T> extends ContentState<T> {}

class ContentErrorState<T> extends ContentState<T> {
  final Exception error;
  ContentErrorState(this.error);
}

class ContentReadyState<T> extends ContentState<T> {
  final T content;
  ContentReadyState(this.content);
}
