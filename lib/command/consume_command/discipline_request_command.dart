import 'package:flutter/foundation.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';

class LoadDisciplineTeacherList {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  LoadDisciplineTeacherList(
      {@required this.discipline,
      @required this.education,
      @required this.semester});
}

class LoadDisciplineDetails {
  final Discipline discipline;
  LoadDisciplineDetails({@required this.discipline});
}

class LoadDisciplineTimetable {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  LoadDisciplineTimetable({
    @required this.discipline,
    @required this.education,
    @required this.semester
  });
}
