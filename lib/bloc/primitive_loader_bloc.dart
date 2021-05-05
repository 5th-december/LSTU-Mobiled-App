import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/state/consuming_state.dart';

class PrimitiveLoaderBloc<TC, TR, TP> extends AbstractBloc<ConsumingState, ConsumingEvent> {
  Stream<ConsumingEvent> get _startConsumingEventStream => this
    .eventController.stream.where((event) => event is StartConsumeEvent<TC>);

  Stream<ConsumingState> get consumingStateStream => this
    .stateContoller.stream.where((event) => event is ConsumingState<TP>);


  PrimitiveLoaderBloc({@required Function loaderFunc, 
    @required Function commandArgumentTranslator, Function valueTranslator})
  {
    if(valueTranslator == null && !(TR is TP)) {
      throw new TypeError();
    }

    this._startConsumingEventStream.listen((event) async {
      TC command = (event as StartConsumeEvent<TC>).request;

      this.updateState(ConsumingLoadingState<TP>());

      var loader = commandArgumentTranslator(loaderFunc, command);
      if(loader is Stream<ConsumingState<TR>>) {
        loader.listen((event) {
          if(event is ConsumingReadyState<TR>) {
            TP value = valueTranslator != null ? valueTranslator(event): event;
            this.updateState(ConsumingReadyState<TP>(value));
          } else if (event is ConsumingErrorState<TR>) {
            this.updateState(ConsumingErrorState<TP>(error: event.error));
          }
        });
      }
      else if (loader is Future<TR>) {
        loader
          .then((value) => this.updateState(ConsumingReadyState<TP>(
            valueTranslator != null ? valueTranslator(event): event)))
          .onError((error, stackTrace) => 
            this.updateState(ConsumingErrorState<TP>(error: error)));
      }
    });
  }
}