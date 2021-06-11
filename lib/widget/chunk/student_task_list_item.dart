import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/student_work.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/page/task_response_page.dart';
import 'package:lk_client/widget/layout/profile_picture.dart';
import 'package:lk_client/widget/list/tasks_answer_list.dart';

class StudentTaskListItem extends StatelessWidget {
  final StudentWork studentWork;
  final Education education;
  final Semester semester;
  final Discipline discipline;
  final TasksListLoaderBloc bloc;

  StudentTaskListItem(
      {@required this.studentWork,
      @required this.education,
      @required this.discipline,
      @required this.semester,
      @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: () {
              List<Widget> teacherDataViewChildren = [];

              if (studentWork.teacher != null) {
                teacherDataViewChildren.add(PersonProfilePicture(
                    displayed: studentWork.teacher.person, size: 14.0));

                String teacherName = studentWork.teacher.person.surname;
                teacherName +=
                    ' ${studentWork.teacher.person.name.substring(0, 1)}.';
                if (studentWork.teacher.person.patronymic != null) {
                  teacherName +=
                      ' ${studentWork.teacher.person.patronymic.substring(0, 1)}.';
                }

                teacherDataViewChildren.add(SizedBox(width: 8.0));
                teacherDataViewChildren.add(Expanded(
                  child: Text(teacherName,
                      style: Theme.of(context).textTheme.bodyText2),
                ));
              } else {
                teacherDataViewChildren.add(Container());
              }

              return teacherDataViewChildren;
            }(),
          ),
          SizedBox(height: 8.0),
          Text(studentWork.workType ?? 'Учебная работа',
              style: Theme.of(context).textTheme.subtitle2),
          SizedBox(height: 8.0),
          Text(studentWork.workName ?? 'Учебное задание',
              style: Theme.of(context).textTheme.headline4),
          SizedBox(height: 10.0),
          studentWork.workTheme != null
              ? Text(studentWork.workTheme,
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Color.fromRGBO(76, 72, 84, 1.0),
                      fontWeight: FontWeight.bold))
              : SizedBox.shrink(),
          studentWork.workTheme != null
              ? SizedBox(height: 12.0)
              : SizedBox.shrink(),
          Text(
            studentWork.answer?.score != null
                ? 'Оценка работы: ${studentWork.answer.score}'
                : 'Работа не оценена',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            'Максимальный балл за работу: ${studentWork.workMaxScore.toString() ?? 'не указан'}',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: () {
              List<Widget> actionButtons = [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return TaskResponsePage(
                          loaderBloc: this.bloc,
                          discipline: this.discipline,
                          semester: this.semester,
                          studentWork: this.studentWork,
                          education: this.education);
                    }));
                  },
                  child: Text('Добавить ответ'),
                )
              ];

              if (studentWork.answer != null &&
                  studentWork.answer.answerAttachments.length != 0) {
                actionButtons.add(SizedBox(
                  width: 4.0,
                ));
                actionButtons.add(ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('Предоставленные ответы'),
                        ),
                        body: TasksAnswerList(
                          answerAttachements:
                              this.studentWork.answer.answerAttachments,
                        ),
                      );
                    }));
                  },
                  child: Text('Просмотр ответов'),
                ));
              }

              return actionButtons;
            }(),
          )
        ],
      ),
    );
  }
}
