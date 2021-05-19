import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lk_client/event/consuming_event.dart';

abstract class AbstractBloc<TS, TE> {
  TS _currentState;

  TS get currentState => _currentState;

  @protected
  StreamController<TS> stateContoller = StreamController<TS>.broadcast();

  StreamController<TE> eventController = StreamController<TE>.broadcast();

  @protected
  StreamController<TS> statusController = StreamController<TS>();
  Stream<TS> get currentStateStream => statusController.stream;

  AbstractBloc() {
    Stream<TE> currentStateEventStream = this
        .eventController
        .stream
        .where((event) => event is GetCurrentStateEvent);
    currentStateEventStream.listen((event) {
      this.statusController.sink.add(_currentState);
    });
  }

  dispose() async {
    await this.stateContoller.close();
    await this.eventController.close();
    await this.statusController.close();
  }

  @protected
  void updateState(TS newState) {
    this._currentState = newState;
    this.stateContoller.sink.add(newState);
  }
}
