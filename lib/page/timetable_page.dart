import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';

class TimetablePage extends StatefulWidget {
  final Education education;
  final Semester semester;

  TimetablePage({Key key, this.education, this.semester}): super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('This is a timetable page')),
    );
  }
}
