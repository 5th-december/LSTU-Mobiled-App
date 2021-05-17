import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/error_handler/validation_error_handler.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/validatable.dart';
import 'package:lk_client/state/producing_state.dart';

abstract class AbstractFormBloc<TQ extends Validatable, TC, TS> extends AbstractBloc<ProducingState<TQ>, ProducingEvent<TQ>> 
{
  Stream<ProducingEvent> get _resourceUpdateEventStream =>
      this.eventController.stream.where((event) => event
          is ProduceResourceEvent<TQ, TC>);

  Stream<ProducingEvent> get _resourceInitEventStram => this
      .eventController
      .stream
      .where((event) => event is ProducerInitEvent<TQ>);

  Stream<ProducingState> get resourseStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ProducingState<TQ>);

  TQ createInitialFormData(TQ argument);

  ValidationErrorBox validateEntity(TQ agument);

  Future<TS> getResponse(TQ request, TC command);

  AbstractFormBloc() {
    this._resourceInitEventStram.listen((event) {
      final _event = event as ProducerInitEvent<TQ>;
      this.updateState(ProducingInitState<TQ>(initData: createInitialFormData(_event.resourse)));
    });

    this._resourceUpdateEventStream.listen((event) async {
      final _event = event as ProduceResourceEvent<TQ, TC>;

      TQ resource = _event.resourse;
      TC command = _event.command;

      this.updateState(ProducingLoadingState<TQ>(data: resource));

      ValidationErrorBox validationErrors = validateEntity(resource);

      if(validationErrors.hasErrors()) {
        this.updateState(ProducingInvalidState<TQ>(validationErrors));
        return;
      }

      try {
        TS response = await this.getResponse(resource, command);
        this.updateState(ProducingReadyState<TQ, TS>(data: resource, response: response));
      } on ValidationException catch(e) {
        this.updateState(ProducingInvalidState<TQ>(validationErrors));
      } on Exception catch(e) {
        this.updateState(ProducingErrorState(e, data: resource));
      }
    });
  }
}