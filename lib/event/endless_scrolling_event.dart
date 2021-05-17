import 'package:flutter/foundation.dart';

abstract class EndlessScrollingEvent<C> {}

class EndlessScrollingLoadEvent<C> extends EndlessScrollingEvent<C> {
  C command;
  EndlessScrollingLoadEvent({@required this.command});
}

class EndlessScrollingLoadNextChunkEvent<C> extends EndlessScrollingEvent<C> {
  C command;
  EndlessScrollingLoadNextChunkEvent({@required this.command});
}