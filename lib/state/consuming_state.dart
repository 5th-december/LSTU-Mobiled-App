import 'package:flutter/foundation.dart';

abstract class ConsumingState<T> {}

class ConsumingInitState<T> extends ConsumingState<T> {}

class ConsumingLoadingState<T> extends ConsumingState<T> {}

class ConsumingErrorState<T> extends ConsumingState<T> {
  final Exception error;
  ConsumingErrorState({@required this.error});
}

class ConsumingReadyState<T> extends ConsumingState<T> {
  final T content;
  ConsumingReadyState(this.content);
}
