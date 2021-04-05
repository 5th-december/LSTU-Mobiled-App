import 'package:flutter/cupertino.dart';
import 'package:lk_client/model/entity/person_entity.dart';

class PersonalPage extends StatefulWidget {
  PersonEntity currentPerson;

  PersonalPage(this.currentPerson);
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  Widget build(BuildContext context) {
    return Center(child: Text('This is a personal page'));
  }
}
