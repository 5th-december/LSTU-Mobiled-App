import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/semester_entity.dart';
import 'package:lk_client/model/entity/subject_entity.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class SubjectListBloc extends AbstractBloc
{
  EducationQueryService _educationQueryService;

  Stream<ContentState> get subjectListContentStateStream => this.stateContoller.stream;

  Stream<ContentEvent> get _subjectListRequestEventStream => this.eventController.stream.where(
    (event) => event is StartLoadingContentEvent<LoadSubjectListCommand>
  );

  SubjectListBloc(this._educationQueryService) {
    this._subjectListRequestEventStream.listen((event) async {
      StartLoadingContentEvent<LoadSubjectListCommand> _event = event as StartLoadingContentEvent<LoadSubjectListCommand>;

      this.updateState(ContentLoadingState<LoadSubjectListCommand>());

      LoadSubjectListCommand loadCmd = _event.request;

      EducationEntity requestedEducation = loadCmd.education;
      SemesterEntity requestedSemester = loadCmd.semester;

      try {
        List<SubjectEntity> loadedSubjects = await this._educationQueryService.getSubjectList(requestedEducation.id, requestedSemester.id);

        this.updateState(ContentReadyState<List<SubjectEntity>>(loadedSubjects));

      } on Exception catch(e) {
        this.updateState(ContentErrorState<LoadSubjectListCommand>(e));
      }

    });
  }
}