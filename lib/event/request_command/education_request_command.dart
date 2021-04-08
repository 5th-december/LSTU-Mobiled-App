import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/person_entity.dart';

abstract class EducationRequestCommand {}

class LoadUserEducationListCommand extends EducationRequestCommand {
  final PersonEntity person;

  LoadUserEducationListCommand(this.person);
}

class LoadSemsterListCommand extends EducationRequestCommand {
  final PersonEntity person;
  final EducationEntity education;

  LoadSemsterListCommand(this.person, this.education);
}
