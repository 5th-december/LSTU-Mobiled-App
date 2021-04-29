import 'package:flutter/cupertino.dart';
import 'package:lk_client/model/person/person.dart';

class TimetablePage extends StatefulWidget {
  Person currentPerson;

  TimetablePage(this.currentPerson);
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Widget build(BuildContext context) {
    return Center(child: Text('This is a timetable page'));
  }
}
