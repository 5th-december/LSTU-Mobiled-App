import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class EducationListBloc extends AbstractBloc<ContentState, ContentEvent> {
  EducationQueryService _educationQueryService;

  Stream<ContentState> get educationListStateStream =>
      this.stateContoller.stream;

  Stream<ContentEvent> get _loadEducationListEventStream =>
      this.eventController.stream.where((event) =>
          event is StartLoadingContentEvent<LoadUserEducationListCommand>);

  EducationListBloc(this._educationQueryService) {
    this._loadEducationListEventStream.listen((event) async {
      StartLoadingContentEvent<LoadUserEducationListCommand> _event =
          event as StartLoadingContentEvent<LoadUserEducationListCommand>;

      PersonEntity requestedPerson = _event.request.person;

      this.updateState(ContentLoadingState<LoadUserEducationListCommand>());

      try {
        List<EducationEntity> educations = await this
            ._educationQueryService
            .getEducationsList(requestedPerson.id);

        this.updateState(ContentReadyState<List<EducationEntity>>(educations));
      } on Exception catch (e) {
        this.updateState(ContentErrorState(e));
      }
    });
  }
}
