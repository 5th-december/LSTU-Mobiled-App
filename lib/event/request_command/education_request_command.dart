import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/education/semester.dart';

abstract class EducationRequestCommand {}

class LoadUserEducationListCommand extends EducationRequestCommand {
  final Person person;

  LoadUserEducationListCommand(this.person);
}

class LoadSemsterListCommand extends EducationRequestCommand {
  final Person person;
  final Education education;

  LoadSemsterListCommand(this.person, this.education);
}

class LoadSubjectListCommand extends EducationRequestCommand {
  final Education education;
  final Semester semester;

  LoadSubjectListCommand(this.education, this.semester);
}

class LoadCurrentEducationsCommand extends EducationRequestCommand {
  final Person person;

  LoadCurrentEducationsCommand(this.person);
}