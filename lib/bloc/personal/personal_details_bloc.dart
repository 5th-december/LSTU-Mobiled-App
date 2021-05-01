import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/user_request_command.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class PersonalDetailsBloc extends AbstractBloc<ContentState, ContentEvent> {
  Stream<ContentEvent> get _personEntityEventStream => this
      .eventController
      .stream
      .where((event) => event is StartLoadingContentEvent<LoadPersonDetails>);

  Stream<ContentState> get personEntityStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ContentState<Person>);

  PersonalDetailsBloc(PersonQueryService personQueryService) {
    this._personEntityEventStream.listen((event) async {
      var _event = event as StartLoadingContentEvent<LoadPersonDetails>;
      Person loadingPerson = _event.request.person;

      this.updateState(ContentLoadingState<Person>());

      try {
        personQueryService
            .getPersonProperties(loadingPerson.id)
            .listen((event) {
          this.updateState(ContentReadyState<Person>(event));
        });
      } on Exception catch (e) {
        this.updateState(ContentErrorState<Person>(e));
      }
    });
  }
}
