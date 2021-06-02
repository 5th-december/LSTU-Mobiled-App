import 'package:flutter/foundation.dart';

abstract class EndlessScrollingEvent {}

class EndlessScrollingInitEvent<T> extends EndlessScrollingEvent {
  final List<T> initialData;
  EndlessScrollingInitEvent({this.initialData});
}

class EndlessScrollingLoadEvent<C> extends EndlessScrollingEvent {
  C command;
  EndlessScrollingLoadEvent({@required this.command});
}

class ExternalDataAddEvent<T> extends EndlessScrollingEvent {
  final List<T> externalAddedData;
  ExternalDataAddEvent({@required this.externalAddedData});
}

class ExternalDataUpdateEvent<T> extends EndlessScrollingEvent {
  final List<T> externalUpdatedData;
  ExternalDataUpdateEvent({@required this.externalUpdatedData});
}
