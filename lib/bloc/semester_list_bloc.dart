import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/model/entity/semester_entity.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class SemesterListBloc extends AbstractBloc<ContentState, ContentEvent> {
  final EducationQueryService _queryService;

  Stream<ContentState> get semesterListStateStream =>
      this.stateContoller.stream;

  Stream<ContentEvent> get _loadSemesterListEventStream =>
      this.eventController.stream.where(
          (event) => event is StartLoadingContentEvent<LoadSemsterListCommand>);

  SemesterListBloc(this._queryService) {
    this._loadSemesterListEventStream.listen((event) async {
      StartLoadingContentEvent<LoadSemsterListCommand> _event =
          event as StartLoadingContentEvent<LoadSemsterListCommand>;

      PersonEntity requestedPerson = _event.request.person;
      EducationEntity requestedEducation = _event.request.education;

      this.updateState(ContentLoadingState<LoadSemsterListCommand>());

      try {
        List<SemesterEntity> receivedSemesters =
            await this._queryService.getSemesterList(requestedEducation.id);

        this.updateState(
            ContentReadyState<List<SemesterEntity>>(receivedSemesters));
      } on Exception catch (e) {
        this.updateState(ContentErrorState(e));
      }
    });
  }
}
