import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class EducationDetailsBloc extends AbstractBloc<ContentState, ContentEvent>
{
  EducationQueryService _queryService;

  Stream<ContentState> get educationDetailsStateStream => this.stateContoller.stream;

  Stream<ContentEvent> get _educationDetailsLoadEventStream => this.eventController.stream.where((event) => event is StartLoadingContentEvent<LoadCurrentEducationsCommand>);

  EducationDetailsBloc(this._queryService) {
    this._educationDetailsLoadEventStream.listen((event) async{
      StartLoadingContentEvent<LoadCurrentEducationsCommand> _event = event as StartLoadingContentEvent<LoadCurrentEducationsCommand>;

      PersonEntity requestedPerson = _event.request.person;

      this.updateState(ContentLoadingState<LoadCurrentEducationsCommand>());

      try {
        List<EducationEntity> educations = await this._queryService.getCurrentEducations(requestedPerson.id);

        this.updateState(ContentReadyState<List<EducationEntity>>(educations));
        
      } on Exception catch(e) {
        this.updateState(ContentErrorState<LoadCurrentEducationsCommand>(e));
      }
    });
  }
}