import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/content_list_state.dart';
import 'package:lk_client/state/content_state.dart';

class SemesterListBloc extends AbstractBloc<ContentState, ContentEvent> {
  final EducationQueryService _queryService;

  Stream<ContentState> get semesterListStateStream =>
      this.stateContoller.stream;

  Stream<ContentEvent> get _loadSemesterListEventStream =>
      this.eventController.stream.where(
          (event) => event is StartLoadingContentEvent<LoadSemsterListCommand>);

  SemesterListBloc(this._queryService, bool allowToSelectCurrentSemester) {
    this._loadSemesterListEventStream.listen((event) async {
      StartLoadingContentEvent<LoadSemsterListCommand> _event =
          event as StartLoadingContentEvent<LoadSemsterListCommand>;

      Education requestedEducation = _event.request.education;

      this.updateState(ContentLoadingState<LoadSemsterListCommand>());

      try {
        this._queryService.getSemesterList(requestedEducation.id).listen((event) {
          List<Semester> semesterList = event.payload;
          if(allowToSelectCurrentSemester) {
            this._queryService.getCurrentSemester(requestedEducation.id).listen((event) {
              final currentSemesterId = event.id;
              Semester currentSemester = semesterList.firstWhere((element) => element.id == currentSemesterId, orElse: () => null);
              if(currentSemesterId != null) {
                this.updateState(SelectSingleDefaultFromList<Semester>(selected: currentSemester));
                return;
              }
            });
          }
          
          this.updateState(ContentReadyState<List<Semester>>(event.payload));
        });

      } on Exception catch (e) {
        this.updateState(ContentErrorState(e));
      }
    });
  }
}
