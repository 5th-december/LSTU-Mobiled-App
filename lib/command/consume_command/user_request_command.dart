import 'package:lk_client/model/person/person.dart';

class LoadCurrentUserIdentifier {}

class LoadPersonDetails {
  final Person person;

  LoadPersonDetails(this.person);
}

class LoadProfilePicture {
  final Person person;
  final double size;

  LoadProfilePicture(this.person, this.size);
}
