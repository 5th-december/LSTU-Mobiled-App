import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';

class SubjectListBloc extends AbstractBloc<ContentState, ContentEvent> {
  EducationQueryService _educationQueryService;

  Stream<ContentState> get subjectListContentStateStream =>
      this.stateContoller.stream;

  Stream<ContentEvent> get _subjectListRequestEventStream =>
      this.eventController.stream.where(
          (event) => event is StartLoadingContentEvent<LoadSubjectListCommand>);

  SubjectListBloc(this._educationQueryService) {
    this._subjectListRequestEventStream.listen((event) async {
      StartLoadingContentEvent<LoadSubjectListCommand> _event =
          event as StartLoadingContentEvent<LoadSubjectListCommand>;

      this.updateState(ContentLoadingState<LoadSubjectListCommand>());

      LoadSubjectListCommand loadCmd = _event.request;

      Education requestedEducation = loadCmd.education;
      Semester requestedSemester = loadCmd.semester;

      try {
        this
            ._educationQueryService
            .getSubjectList(requestedEducation.id, requestedSemester.id)
            .listen((event) {
          this.updateState(ContentReadyState<List<Discipline>>(event.payload));
        });
      } on Exception catch (e) {
        this.updateState(ContentErrorState<LoadSubjectListCommand>(e));
      }
    });
  }
}
