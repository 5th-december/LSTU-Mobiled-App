import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/timetable_section_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/timetable_page.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/timetable_section_state.dart';

class TimetablePageManagerBloc
    extends AbstractBloc<TimetableSectionState, TimetableSectionEvent> {
  Stream<TimetableSectionState> get timetableSectionStateStream =>
      this.stateContoller.stream.where((event) => event is TimetableSectionState);

  Stream<TimetableSectionEvent> get _timetableSectionEventStream =>
      this.eventController.stream.where((event) => event is TimetableSectionEvent);

  EducationQueryService educationQueryService;

  TimetablePageManagerBloc({@required this.educationQueryService}) {
    this._timetableSectionEventStream.listen((event) {

      if (this.currentState is TimetableCustomSelection) {
        if(event is ProvideEducationData) {
          this.updateState(WaitForSemesterData(education: event.education));
        } else if (event is ProvideSemesterData) {
          this.updateState(SelectedCustomTimetable(semester: event.semester, education: event.education));
        }
      } else {
        if (event is TimetableLoadingMethodAutoSelect || event is ForceDefaultTimetableSelection) {
          this.updateState(TimetableDefaultSelectionLoading());
          Person person = (event as StartTimetableSelectionRequest).person;
          try {
            this.educationQueryService.getEducationsList(person.id).listen((event) {
              List<Education> eduList = event.payload;
              if(eduList.length == 1) {
                this.educationQueryService.getCurrentSemester(eduList[0].id).listen((event) {
                  this.updateState(SelectedTimetableByDefault(education: eduList[0], semester: event));
                });
              } else {
                if(event is ForceDefaultTimetableSelection) {
                  this.updateState(TimetableDefaultSelectionError());
                } else {
                  this.updateState(WaitForEducationData(currentPerson: person));
                }
              }
            });
          } on Exception catch(e) {
            if(event is ForceDefaultTimetableSelection) {
              this.updateState(TimetableDefaultSelectionError());
            } else {
              this.updateState(WaitForEducationData(currentPerson: person));
            }
          }
        } else if (event is ForceCustomTimetableSelection) {
          this.updateState(WaitForEducationData(currentPerson: event.person));
        }
      }
    });
  }
}
