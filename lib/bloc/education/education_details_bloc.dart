import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class EducationDetailsBloc extends AbstractBloc<ContentState, ContentEvent>
{
  EducationQueryService _queryService;

  Stream<ContentState> get educationDetailsStateStream => this.stateContoller.stream;

  Stream<ContentEvent> get _educationDetailsLoadEventStream => this.eventController.stream.where((event) => event is StartLoadingContentEvent<LoadCurrentEducationsCommand>);

  EducationDetailsBloc(this._queryService) {
    this._educationDetailsLoadEventStream.listen((event) async{
      StartLoadingContentEvent<LoadCurrentEducationsCommand> _event = event as StartLoadingContentEvent<LoadCurrentEducationsCommand>;

      Person requestedPerson = _event.request.person;

      this.updateState(ContentLoadingState<LoadCurrentEducationsCommand>());

      try {
        //await this._queryService.getCurrentEducations(requestedPerson.id).lis

        //this.updateState(ContentReadyState<List<Education>>(educations));
        
      } on Exception catch(e) {
        this.updateState(ContentErrorState<LoadCurrentEducationsCommand>(e));
      }
    });
  }
}