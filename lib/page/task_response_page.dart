import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';

class TaskResponsePage extends StatefulWidget {
  final Discipline discipline;

  final Semester semester;

  final Education education;

  TaskResponsePage(
      {Key key,
      @required this.discipline,
      @required this.education,
      @required this.semester});

  @override
  State<TaskResponsePage> createState() => TaskResponsePageState();
}

class TaskResponsePageState extends State<TaskResponsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ответ на задание'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Column(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ElevatedButton(
                  child: Text('Отправить'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
