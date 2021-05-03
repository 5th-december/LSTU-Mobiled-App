import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/content_list_state.dart';
import 'package:lk_client/state/content_state.dart';

class EducationListBloc extends AbstractBloc<ContentState, ContentEvent> {
  EducationQueryService _educationQueryService;

  Stream<ContentState> get educationListStateStream =>
      this.stateContoller.stream;

  Stream<ContentEvent> get _loadEducationListEventStream =>
      this.eventController.stream.where((event) =>
          event is StartLoadingContentEvent<LoadUserEducationListCommand>);

  EducationListBloc(this._educationQueryService, bool allowToSelectByDefault) {
    this._loadEducationListEventStream.listen((event) async {
      StartLoadingContentEvent<LoadUserEducationListCommand> _event =
          event as StartLoadingContentEvent<LoadUserEducationListCommand>;

      Person requestedPerson = _event.request.person;

      this.updateState(ContentLoadingState<LoadUserEducationListCommand>());

      try {
        this._educationQueryService.getEducationsList(requestedPerson.id).listen((ListedResponse<Education> edu) {
          List<Education> loadedEducationList = edu.payload;

          if(loadedEducationList.length == 1 && allowToSelectByDefault == true) {
            this.updateState(SelectSingleDefaultFromList<Education>(selected: loadedEducationList[0]));
            return;
          }

          this.updateState(ContentReadyState<List<Education>>(edu.payload));
        });

      } on Exception catch (e) {
        this.updateState(ContentErrorState(e));
      }
    });
  }
}
