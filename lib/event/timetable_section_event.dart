import 'package:flutter/foundation.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';

abstract class TimetableSectionEvent {}

class StartTimetableSelectionRequest {
  final Person person;
  StartTimetableSelectionRequest({@required this.person});
}

class TimetableLoadingMethodAutoSelect extends StartTimetableSelectionRequest
    implements TimetableSectionEvent {
  TimetableLoadingMethodAutoSelect({@required person}) : super(person: person);
}

class ForceCustomTimetableSelection extends StartTimetableSelectionRequest
    implements TimetableSectionEvent {
  final bool allowSwitchToDefault;
  ForceCustomTimetableSelection(
      {@required person, this.allowSwitchToDefault = true})
      : super(person: person);
}

class ForceDefaultTimetableSelection extends StartTimetableSelectionRequest
    implements TimetableSectionEvent {
  ForceDefaultTimetableSelection({@required person}) : super(person: person);
}

class ProvideEducationData implements TimetableSectionEvent {
  final Education education;
  final bool allowSwitchToDefault;
  ProvideEducationData(
      {@required this.education, this.allowSwitchToDefault = true});
}

class ProvideSemesterData implements TimetableSectionEvent {
  final Education education;
  final Semester semester;
  final bool allowSwitchToDefault;
  ProvideSemesterData(
      {@required this.education,
      @required this.semester,
      this.allowSwitchToDefault = true});
}
