import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class AbstractBloc<TS, TE> {
  TS _currentState;

  TS get currentState => _currentState;

  @protected
  StreamController<TS> stateContoller = StreamController<TS>.broadcast();

  StreamController<TE> eventController = StreamController<TE>.broadcast();

  dispose() async {
    await this.stateContoller.close();
    await this.eventController.close();
  }

  @protected
  void updateState(TS newState) {
    this._currentState = newState;
    this.stateContoller.sink.add(newState);
  }
}
