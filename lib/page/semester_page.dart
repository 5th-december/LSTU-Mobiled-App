import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/widget/semester_list.dart';

class SemesterPage extends StatefulWidget {
  final Education _education;
  final bool _allowToSelectCurrent;
  final Function _navigateToNextPage;

  SemesterPage(this._education, this._allowToSelectCurrent, this._navigateToNextPage);

  @override
  _SemesterPageState createState() => _SemesterPageState();
}

class _SemesterPageState extends State<SemesterPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Семестры'),
      ),
      body: SemesterList(widget._education, widget._allowToSelectCurrent, widget._navigateToNextPage)
    );
  }
}
