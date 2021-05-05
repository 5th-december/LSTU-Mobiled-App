import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/user_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class PersonalDetailsBloc extends AbstractBloc<ConsumingState, ConsumingEvent> {
  Stream<ConsumingEvent> get _personEntityEventStream => this
      .eventController
      .stream
      .where((event) => event is StartConsumeEvent<LoadPersonDetails>);

  Stream<ConsumingState> get personEntityStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ConsumingState<Person>);

  PersonalDetailsBloc(PersonQueryService personQueryService) {
    this._personEntityEventStream.listen((event) async {
      var _event = event as StartConsumeEvent<LoadPersonDetails>;
      Person loadingPerson = _event.request.person;

      this.updateState(ConsumingLoadingState<Person>());

      try {
        personQueryService
            .getPersonProperties(loadingPerson.id)
            .listen((event) {
          this.updateState(ConsumingReadyState<Person>(event));
        });
      } on Exception catch (e) {
        this.updateState(ConsumingErrorState<Person>(error: e));
      }
    });
  }
}
