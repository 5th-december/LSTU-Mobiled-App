import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class EducationListBloc extends AbstractBloc<ConsumingState, ConsumingEvent> {
  EducationQueryService _educationQueryService;

  Stream<ConsumingState> get educationListStateStream =>
      this.stateContoller.stream;

  Stream<ConsumingEvent> get _loadEducationListEventStream =>
      this.eventController.stream.where((event) =>
          event is StartConsumeEvent<LoadUserEducationListCommand>);

  EducationListBloc(this._educationQueryService) {
    this._loadEducationListEventStream.listen((event) async {
      StartConsumeEvent<LoadUserEducationListCommand> _event =
          event as StartConsumeEvent<LoadUserEducationListCommand>;

      Person requestedPerson = _event.request.person;

      this.updateState(ConsumingLoadingState<LoadUserEducationListCommand>());

      try {
        this
            ._educationQueryService
            .getEducationsList(requestedPerson.id)
            .listen((ListedResponse<Education> edu) {
          this.updateState(ConsumingReadyState<List<Education>>(edu.payload));
        });
      } on Exception catch (e) {
        this.updateState(ConsumingErrorState(error: e));
      }
    });
  }
}
