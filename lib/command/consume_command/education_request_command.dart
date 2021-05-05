import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/education/semester.dart';

class LoadUserEducationListCommand {
  final Person person;

  LoadUserEducationListCommand(this.person);
}

class LoadSemsterListCommand {
  final Education education;

  LoadSemsterListCommand(this.education);
}

class LoadSubjectListCommand {
  final Education education;
  final Semester semester;

  LoadSubjectListCommand(this.education, this.semester);
}

class LoadCurrentEducationsCommand {
  final Person person;

  LoadCurrentEducationsCommand(this.person);
}