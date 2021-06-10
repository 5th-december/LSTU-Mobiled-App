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
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: ListView(children: [
            DisciplineDetails(discipline: widget.discipline),
            Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: 18.0,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
                    child: Text(
                      'Преподаватели',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              DisciplineTeachersList(
                discipline: widget.discipline,
                education: widget.education,
                semester: widget.semester,
              ),
              SizedBox(
                height: 12.0,
              )
            ]),
            Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: 18.0,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
                    child: Text(
                      'Расписание',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              TimetableHorizontalList(
                  discipline: widget.discipline,
                  semester: widget.semester,
                  education: widget.education),
              SizedBox(
                height: 12.0,
              )
            ]),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 18.0,
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
                      child: Text(
                        'Ресурсы',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Container(
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(165, 153, 255, 1.0)),
                      child: Center(
                        child: Icon(
                          Icons.library_books_rounded,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    title: Text('Материалы дисциплины'),
                    onTap: () => {
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
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text('Обсуждение'),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(165, 153, 255, 1.0)),
                      child: Center(
                        child: Icon(
                          Icons.forum_rounded,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext builder) {
                      return DiscussionPage(
                        discipline: widget.discipline,
                        semester: widget.semester,
                        education: widget.education,
                        person: widget.person,
                      );
                    })),
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text('Задания'),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(165, 153, 255, 1.0)),
                      child: Center(
                        child: Icon(
                          Icons.rule_rounded,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return TasksPage(
                          discipline: widget.discipline,
                          education: widget.education,
                          semester: widget.semester);
                    })),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                )
              ],
            )
          ]),
        ),
        bottomNavigationBar: BottomNavigator());
  }
}
