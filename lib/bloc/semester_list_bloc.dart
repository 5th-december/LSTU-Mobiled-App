import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class SemesterListBloc extends AbstractBloc<ConsumingState, ConsumingEvent> {
  final EducationQueryService _queryService;

  Stream<ConsumingState> get semesterListStateStream =>
      this.stateContoller.stream;

  Stream<ConsumingEvent> get _loadSemesterListEventStream =>
      this.eventController.stream.where(
          (event) => event is StartConsumeEvent<LoadSemsterListCommand>);

  SemesterListBloc(this._queryService) {
    this._loadSemesterListEventStream.listen((event) async {
      StartConsumeEvent<LoadSemsterListCommand> _event =
          event as StartConsumeEvent<LoadSemsterListCommand>;

      Education requestedEducation = _event.request.education;

      this.updateState(ConsumingLoadingState<LoadSemsterListCommand>());

      try {
        this
            ._queryService
            .getSemesterList(requestedEducation.id)
            .listen((event) {
          this.updateState(ConsumingReadyState<List<Semester>>(event.payload));
        });
      } on Exception catch (e) {
        this.updateState(ConsumingErrorState(error: e));
      }
    });
  }
}
