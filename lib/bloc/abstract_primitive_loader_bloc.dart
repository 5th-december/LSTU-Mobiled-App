import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/state/consuming_state.dart';

abstract class AbstractPrimitiveLoaderBloc<TC, TR, TP>
    extends AbstractBloc<ConsumingState, ConsumingEvent> {
  Stream<ConsumingEvent> get _startConsumingEventStream => this
      .eventController
      .stream
      .where((event) => event is StartConsumeEvent<TC>);

  Stream<ConsumingState> get consumingStateStream =>
      this.stateContoller.stream.where((event) => event is ConsumingState<TP>);

  Function loaderFunc;
  dynamic commandArgumentTranslator(Function loaderFunc, TC command);
  TP valueTranslator(TR argument);

  AbstractPrimitiveLoaderBloc() {
    if (valueTranslator == null && TR != TP) {
      throw new TypeError();
    }

    this._startConsumingEventStream.listen((event) async {
      TC command = (event as StartConsumeEvent<TC>).request;

      this.updateState(ConsumingLoadingState<TP>());

      var loader = commandArgumentTranslator(this.loaderFunc, command);
      if (loader is Stream<ConsumingState<TR>>) {
        loader.listen((event) {
          if (event is ConsumingReadyState<TR>) {
            TP value = valueTranslator != null
                ? valueTranslator(event.content)
                : event.content;
            this.updateState(ConsumingReadyState<TP>(value));
          } else if (event is ConsumingErrorState<TR>) {
            this.updateState(ConsumingErrorState<TP>(error: event.error));
          }
        });
      } else if (loader is Future<TR>) {
        loader
            .then((value) => this.updateState(ConsumingReadyState<TP>(
                valueTranslator != null ? valueTranslator(value) : value)))
            .onError((error, stackTrace) =>
                this.updateState(ConsumingErrorState<TP>(error: error)));
      }
    });
  }
}
