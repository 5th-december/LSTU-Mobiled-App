import 'package:flutter/foundation.dart';

abstract class EndlessScrollingEvent<C> {}

class EndlessScrollingLoadChunkEvent<C> extends EndlessScrollingEvent<C> {
  C command;
  EndlessScrollingLoadChunkEvent({@required this.command});
}