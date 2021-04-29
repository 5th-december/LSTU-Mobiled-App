import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/discipline/discipline.dart';

class SubjectViewPage extends StatefulWidget {
  Discipline _currentSubject;

  SubjectViewPage(this._currentSubject);

  @override
  _SubjectViewPageState createState() => _SubjectViewPageState();
}

class _SubjectViewPageState extends State<SubjectViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Дисциплина'),
      ),
      body: Center(child: Text(widget._currentSubject.name)),
    );
  }
}
