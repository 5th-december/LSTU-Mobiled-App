import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class EducationDetailsBloc extends AbstractBloc<ConsumingState, ConsumingEvent> {
  EducationQueryService _queryService;

  Stream<ConsumingState> get educationDetailsStateStream =>
      this.stateContoller.stream;

  Stream<ConsumingEvent> get _educationDetailsLoadEventStream =>
      this.eventController.stream.where((event) =>
          event is StartConsumeEvent<LoadCurrentEducationsCommand>);

  EducationDetailsBloc(this._queryService) {
    this._educationDetailsLoadEventStream.listen((event) async {
      StartConsumeEvent<LoadCurrentEducationsCommand> _event =
          event as StartConsumeEvent<LoadCurrentEducationsCommand>;

      Person requestedPerson = _event.request.person;

      this.updateState(ConsumingLoadingState<LoadCurrentEducationsCommand>());

      try {
        this
            ._queryService
            .getEducationsList(requestedPerson.id)
            .listen((event) {
          this.updateState(ConsumingReadyState<List<Education>>(event.payload));
        });
      } on Exception catch (e) {
        this.updateState(ConsumingErrorState<LoadCurrentEducationsCommand>(error: e));
      }
    });
  }
}
