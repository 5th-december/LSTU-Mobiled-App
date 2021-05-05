import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/widget/layout/discipline_details.dart';
import 'package:lk_client/widget/list/discipline_teachers_list.dart';

class DisciplinePage extends StatefulWidget {
  final Discipline discipline;
  final Education education;
  final Semester semester;

  DisciplinePage(
      {Key key,
      @required this.discipline,
      @required this.education,
      @required this.semester})
      : super(key: key);

  @override
  _DisciplinePageState createState() => _DisciplinePageState();
}

class _DisciplinePageState extends State<DisciplinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Дисциплина'),
        ),
        body: Column(
          children: [
            DisciplineDetails(discipline: widget.discipline),
            DisciplineTeachersList(
              discipline: widget.discipline,
              education: widget.education,
              semester: widget.semester,
            )
          ],
        ));
  }
}
