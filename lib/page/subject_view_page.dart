import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/entity/subject_entity.dart';

class SubjectViewPage extends StatefulWidget {
  SubjectEntity _currentSubject;

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
      body: Center(child: Text(widget._currentSubject.subjectName)),
    );
  }
}
