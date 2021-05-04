import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/timetable_section_event.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/timetable_section_state.dart';

class TimetablePageManagerBloc
    extends AbstractBloc<TimetableSectionState, TimetableSectionEvent> {
  Stream<TimetableSectionState> get timetableSectionStateStream =>
      this.stateContoller.stream;

  Stream<TimetableSectionEvent> get _timetableSectionEventStream =>
      this.eventController.stream;

  EducationQueryService educationQueryService;

  TimetablePageManagerBloc({@required this.educationQueryService}) {}
}
