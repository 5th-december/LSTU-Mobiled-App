import 'package:lk_client/model/person/person.dart';

abstract class UserRequestCommand {}

class LoadCurrentUserIdentifier extends UserRequestCommand {}

class LoadPersonDetails extends UserRequestCommand {
  final Person person;

  LoadPersonDetails(this.person);
}

class LoadProfilePicture extends UserRequestCommand {
  final Person person;
  final double size;

  LoadProfilePicture(this.person, this.size);
}
