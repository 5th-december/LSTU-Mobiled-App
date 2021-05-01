import 'package:lk_client/model/person/person.dart';

abstract class UserProduceCommand {}

class InitCommand extends UserProduceCommand {}

class UploadUserContacts {
  Person person;

  UploadUserContacts(this.person);
}
