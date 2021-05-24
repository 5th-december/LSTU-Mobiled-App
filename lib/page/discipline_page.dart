import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/discussion_page.dart';
import 'package:lk_client/page/tasks_page.dart';
import 'package:lk_client/widget/layout/discipline_details.dart';
import 'package:lk_client/widget/list/discipline_teachers_list.dart';
import 'package:lk_client/widget/list/teach_materials_list.dart';
import 'package:lk_client/widget/list/timetable_horizontal_list.dart';
import 'package:lk_client/widget/util/bottom_navigator.dart';

class DisciplinePage extends StatefulWidget {
  final Discipline discipline;
  final Education education;
  final Semester semester;
  final Person person;

  DisciplinePage(
      {Key key,
      @required this.discipline,
      @required this.education,
      @required this.person,
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
        body: ListView(
          children: [
            DisciplineDetails(discipline: widget.discipline),
            DisciplineTeachersList(
              discipline: widget.discipline,
              education: widget.education,
              semester: widget.semester,
            ),
            TimetableHorizontalList(
                discipline: widget.discipline,
                semester: widget.semester,
                education: widget.education),
            ElevatedButton(
                onPressed: () => {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: Text('Материалы дисциплины'),
                          ),
                          body: TeachMaterialsList(
                            education: widget.education,
                            semester: widget.semester,
                            discipline: widget.discipline,
                          ),
                          bottomNavigationBar: BottomNavigator(),
                        );
                      }))
                    },
                child: Text('Материалы')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext builder) {
                      return DiscussionPage(
                        discipline: widget.discipline,
                        semester: widget.semester,
                        education: widget.education,
                        person: widget.person,
                      );
                    })),
                child: Text('Обсуждение')),
            ElevatedButton(
              child: Text('Задания'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return TasksPage(
                    discipline: widget.discipline,
                    education: widget.education,
                    semester: widget.semester);
              })),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigator());
  }
}
