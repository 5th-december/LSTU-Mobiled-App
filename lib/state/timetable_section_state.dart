import 'package:flutter/foundation.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';

abstract class TimetableSectionState {}

abstract class TimetableReadyState {
  Education education;
  Semester semester;
  TimetableReadyState({this.education, this.semester});
}

class SelectedTimetableByDefault extends TimetableReadyState implements TimetableSectionState {
  SelectedTimetableByDefault({Education education, Semester semester}): super(education: education, semester: semester);
}

class SelectedCustomTimetable extends TimetableSectionState {
  Education education;
  Semester semester;
  SelectedCustomTimetable({this.education, this.semester});
}

class TimetableDefaultSelectionLoading implements TimetableSectionState {}

class TimetableDefaultSelectionError implements TimetableSectionState {}

abstract class TimetableCustomSelection {}

class WaitForEducationData implements TimetableSectionState, TimetableCustomSelection {
  Person currentPerson;
  WaitForEducationData({@required this.currentPerson});
}

class WaitForSemesterData implements TimetableSectionState, TimetableCustomSelection {
  Education education;
  WaitForSemesterData({@required this.education});
}