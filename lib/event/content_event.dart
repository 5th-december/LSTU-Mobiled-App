abstract class ContentEvent<T> {}

class StartLoadingContentEvent<T> {
  final T request;
  StartLoadingContentEvent(this.request);
}
