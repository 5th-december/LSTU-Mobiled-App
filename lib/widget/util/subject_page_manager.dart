import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/discipline_page.dart';
import 'package:lk_client/widget/list/discipline_list.dart';
import 'package:lk_client/widget/list/education_list.dart';
import 'package:lk_client/widget/list/semester_list.dart';

class SubjectPageManager extends StatefulWidget {
  final Person currentPerson;

  SubjectPageManager({Key key, @required this.currentPerson}) : super(key: key);

  @override
  _SubjectPageManagerState createState() => _SubjectPageManagerState();
}

class _SubjectPageManagerState extends State<SubjectPageManager> {
  @override
  Widget build(BuildContext context) {
    return getEducationListPage((Education selectedEducation) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return getSemestersListPage(selectedEducation,
            (Semester selectedSemester) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return getSubjectsListPage(selectedEducation, selectedSemester,
                (Discipline selectedDiscipline) {
              Future.delayed(
                  Duration(seconds: 0),
                  () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return DisciplinePage(
                            discipline: selectedDiscipline,
                            semester: selectedSemester,
                            education: selectedEducation);
                      })));
            });
          }));
        });
      }));
    });
  }

  Widget getEducationListPage(Function onItemTap) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Периоды обучения'),
        ),
        body: EducationList(widget.currentPerson, onItemTap));
  }

  Widget getSemestersListPage(Education education, Function onItemTap) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Семестры'),
        ),
        body: SemesterList(education, onItemTap));
  }

  Widget getSubjectsListPage(
      Education education, Semester semester, Function onItemTap) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Дисциплины'),
        ),
        body: DisciplineList(
            education: education, semester: semester, onItemTap: onItemTap));
  }
}
