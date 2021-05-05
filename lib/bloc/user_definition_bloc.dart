import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/user_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class UserDefinitionBloc extends AbstractBloc<ConsumingState, ConsumingEvent> {
  Stream<ConsumingState> get personDefinitionStateSteream => this
      .stateContoller
      .stream
      .where((event) => event is ConsumingState<Person>);

  Stream<ConsumingEvent> get _personDefinitionEventStream =>
      this.eventController.stream.where((event) =>
          event is StartConsumeEvent<LoadCurrentUserIdentifier>);

  UserDefinitionBloc(PersonQueryService queryService) {
    this._personDefinitionEventStream.listen((event) {
      this.updateState(ConsumingLoadingState<Person>());

      try {
        queryService.getCurrentPersonIdentifier().listen((event) {
          this.updateState(ConsumingReadyState<Person>(event));
        });
      } on Exception catch (e) {
        this.updateState(ConsumingErrorState<Person>(error: e));
      }
    });
  }
}
