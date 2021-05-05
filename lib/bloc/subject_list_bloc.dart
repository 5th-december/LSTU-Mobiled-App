import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class SubjectListBloc extends AbstractBloc<ConsumingState, ConsumingEvent> {
  EducationQueryService _educationQueryService;

  Stream<ConsumingState> get subjectListContentStateStream =>
      this.stateContoller.stream;

  Stream<ConsumingEvent> get _subjectListRequestEventStream =>
      this.eventController.stream.where(
          (event) => event is StartConsumeEvent<LoadSubjectListCommand>);

  SubjectListBloc(this._educationQueryService) {
    this._subjectListRequestEventStream.listen((event) async {
      StartConsumeEvent<LoadSubjectListCommand> _event =
          event as StartConsumeEvent<LoadSubjectListCommand>;

      this.updateState(ConsumingLoadingState<LoadSubjectListCommand>());

      LoadSubjectListCommand loadCmd = _event.request;

      Education requestedEducation = loadCmd.education;
      Semester requestedSemester = loadCmd.semester;

      try {
        this
            ._educationQueryService
            .getSubjectList(requestedEducation.id, requestedSemester.id)
            .listen((event) {
          this.updateState(ConsumingReadyState<List<Discipline>>(event.payload));
        });
      } on Exception catch (e) {
        this.updateState(ConsumingErrorState<LoadSubjectListCommand>(error: e));
      }
    });
  }
}
