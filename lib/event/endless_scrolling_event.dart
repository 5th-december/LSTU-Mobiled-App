import 'package:flutter/foundation.dart';

abstract class EndlessScrollingEvent {}

class EndlessScrollingInitEvent<T> extends EndlessScrollingEvent {
  final List<T> initialData;
  EndlessScrollingInitEvent({this.initialData});
}

abstract class LoadChunkEvent<C> {
  final C command;
  LoadChunkEvent({@required this.command});
}

class LoadFirstChunkEvent<C> extends LoadChunkEvent<C>
    implements EndlessScrollingEvent {
  LoadFirstChunkEvent({@required command}) : super(command: command);
}

class LoadNextChunkEvent<C> extends LoadChunkEvent<C>
    implements EndlessScrollingEvent {
  LoadNextChunkEvent({@required command}) : super(command: command);
}

class ExternalDataAddEvent<T> extends EndlessScrollingEvent {
  final List<T> externalAddedData;
  ExternalDataAddEvent({@required this.externalAddedData});
}

class ExternalDataUpdateEvent<T> extends EndlessScrollingEvent {
  final List<T> externalUpdatedData;
  ExternalDataUpdateEvent({@required this.externalUpdatedData});
}
