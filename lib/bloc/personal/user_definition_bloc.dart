import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/user_request_command.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class UserDefinitionBloc extends AbstractBloc<ContentState, ContentEvent> {
  Stream<ContentState> get personDefinitionStateSteream => this
      .stateContoller
      .stream
      .where((event) => event is ContentState<Person>);

  Stream<ContentEvent> get _personDefinitionEventStream =>
      this.eventController.stream.where((event) =>
          event is StartLoadingContentEvent<LoadCurrentUserIdentifier>);

  UserDefinitionBloc(PersonQueryService queryService) {
    this._personDefinitionEventStream.listen((event) {
      this.updateState(ContentLoadingState<Person>());

      try {
        queryService.getCurrentPersonIdentifier().listen((event) {
          this.updateState(ContentReadyState<Person>(event));
        });
      } on Exception catch (e) {
        this.updateState(ContentErrorState<Person>(e));
      }
    });
  }
}
