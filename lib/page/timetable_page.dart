import 'package:flutter/cupertino.dart';
import 'package:lk_client/model/entity/person_entity.dart';

class TimetablePage extends StatefulWidget {
  PersonEntity currentPerson;

  TimetablePage(this.currentPerson);
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Widget build(BuildContext context) {
    return Center(child: Text('This is a timetable page'));
  }
}
