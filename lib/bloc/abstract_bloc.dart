import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lk_client/event/consuming_event.dart';

abstract class AbstractBloc<TS, TE> {
  TS _currentState;

  TS get currentState => _currentState;

  @protected
  StreamController<TS> stateContoller = StreamController<TS>.broadcast();

  StreamController<TE> eventController = StreamController<TE>.broadcast();

  StreamController serviceController = StreamController.broadcast();

  AbstractBloc() {
    Stream currentStateEventStream = this
        .serviceController
        .stream
        .where((event) => event is GetCurrentStateEvent);
    currentStateEventStream.listen((event) {
      this.stateContoller.sink.add(_currentState);
    });
  }

  dispose() async {
    await this.stateContoller.close();
    await this.eventController.close();
    await this.serviceController.close();
  }

  @protected
  void updateState(TS newState) {
    this._currentState = newState;
    this.stateContoller.sink.add(newState);
  }
}
