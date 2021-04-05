abstract class ContentState<T> {}

class ContentInitState<T> extends ContentState<T> {}

class ContentLoadingState<T> extends ContentState<T> {}

class ContentReadyState<T> extends ContentState<T> {
  final T content;
  ContentReadyState(this.content);
}