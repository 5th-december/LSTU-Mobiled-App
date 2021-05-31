import 'package:flutter/foundation.dart';

abstract class ConsumingEvent<T> {}

class StartConsumeEvent<T> extends ConsumingEvent<T> {
  final T request;
  StartConsumeEvent({@required this.request});
}
