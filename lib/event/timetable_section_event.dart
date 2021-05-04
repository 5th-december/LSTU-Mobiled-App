import 'package:flutter/foundation.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';

abstract class TimetableSectionEvent {}

class StartTimetableSelectionRequest {
  Person person;
  StartTimetableSelectionRequest({@required this.person});
}

class TimetableLoadingMethodAutoSelect extends StartTimetableSelectionRequest implements TimetableSectionEvent {
  TimetableLoadingMethodAutoSelect({@required person}): super(person: person);
}

class ForceCustomTimetableSelection extends StartTimetableSelectionRequest implements TimetableSectionEvent {
  ForceCustomTimetableSelection({@required person}): super(person: person);
}

class ForceDefaultTimetableSelection extends StartTimetableSelectionRequest implements TimetableSectionEvent {
  ForceDefaultTimetableSelection({@required person}): super(person: person);
}

class ProvideEducationData implements TimetableSectionEvent {
  Education education;
  ProvideEducationData({@required this.education});
}

class ProvideSemesterData implements TimetableSectionEvent {
  Education education;
  Semester semester;
  ProvideSemesterData({@required this.education, @required this.semester});
}