abstract class ContentEvent<T> {}

class StartLoadingContentEvent<T> extends ContentEvent<T> {
  final T request;
  StartLoadingContentEvent(this.request);
}
