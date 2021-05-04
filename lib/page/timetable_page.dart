import 'package:flutter/cupertino.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';

class TimetablePage extends StatefulWidget {
  Education _education;
  Semester _semester;

  TimetablePage(Person person) {}

  //TimetablePage(this._education, this._semester);
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Widget build(BuildContext context) {
    return Center(child: Text('This is a timetable page'));
  }
}
