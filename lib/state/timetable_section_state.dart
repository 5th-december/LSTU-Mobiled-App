import 'package:flutter/foundation.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';

abstract class TimetableSectionState {}

abstract class TimetableReadyState {
  final Education education;
  final Semester semester;
  TimetableReadyState({@required this.education, @required this.semester});
}

class SelectedTimetableByDefault extends TimetableReadyState
    implements TimetableSectionState {
  SelectedTimetableByDefault(
      {@required Education education, @required Semester semester})
      : super(education: education, semester: semester);
}

class SelectedCustomTimetable extends TimetableReadyState
    implements TimetableSectionState {
  bool allowSwitchToDefault;
  SelectedCustomTimetable(
      {@required education,
      @required semester,
      this.allowSwitchToDefault = true})
      : super(education: education, semester: semester);
}

class TimetableDefaultSelectionLoading implements TimetableSectionState {}

class TimetableDefaultSelectionError implements TimetableSectionState {}

abstract class TimetableCustomSelection {}

class WaitForEducationData
    implements TimetableSectionState, TimetableCustomSelection {
  final Person currentPerson;
  final bool allowSwitchToDefault;
  WaitForEducationData(
      {@required this.currentPerson, this.allowSwitchToDefault = true});
}

class WaitForSemesterData
    implements TimetableSectionState, TimetableCustomSelection {
  final Education education;
  final bool allowSwitchToDefault;
  WaitForSemesterData(
      {@required this.education, this.allowSwitchToDefault = true});
}
