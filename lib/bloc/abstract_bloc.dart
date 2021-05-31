import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class AbstractBloc<TS, TE> {
  TS get currentState =>
      this.stateContoller.hasValue ? this.stateContoller.value : null;
  TE get currentCommand =>
      this.eventController.hasValue ? this.eventController.value : null;

  @protected
  BehaviorSubject<TS> stateContoller = BehaviorSubject<TS>();

  BehaviorSubject<TE> eventController = BehaviorSubject<TE>();

  dispose() async {
    await this.stateContoller.close();
    await this.eventController.close();
  }

  @protected
  void updateState(TS newState) {
    this.stateContoller.sink.add(newState);
  }
}
