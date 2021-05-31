import 'package:flutter/foundation.dart';

abstract class EndlessScrollingEvent {}

class EndlessScrollingLoadEvent<C> extends EndlessScrollingEvent {
  C command;
  EndlessScrollingLoadEvent({@required this.command});
}

class ExternalDataAddEvent<T> extends EndlessScrollingEvent {
  final List<T> externalAddedData;
  ExternalDataAddEvent({@required this.externalAddedData});
}
