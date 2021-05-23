import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/widget/layout/profile_picture.dart';

class TimetableListItem extends StatelessWidget {
  final TimetableItem lesson;

  TimetableListItem({Key key, @required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  this.lesson.discipline.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.grey.shade900),
                ),
                SizedBox(height: 6.0),
                Row(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 16.0,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8.0),
                    Text(this.lesson.lessonType ?? 'Занятие по дисциплине',
                        style: TextStyle(color: Colors.grey, fontSize: 14.0))
                  ],
                ),
                SizedBox(height: 12.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: () {
                    List<Widget> teacherDataViewChildren = [];
                    if (this.lesson.teacher != null) {
                      teacherDataViewChildren.add(PersonProfilePicture(
                          displayed: this.lesson.teacher.person, size: 18.0));
                      teacherDataViewChildren.add(SizedBox(width: 8.0));
                      final teacherPos =
                          this.lesson.teacher.position ?? 'преподаватель';
                      final teacherSurname =
                          this.lesson.teacher.person.surname ?? '';
                      final teacherName = this.lesson.teacher.person.name ?? '';
                      final teacherPatronymic =
                          this.lesson.teacher.person.patronymic ?? '';
                      teacherDataViewChildren.add(Expanded(
                        child: Text(
                            '$teacherPos $teacherSurname $teacherName $teacherPatronymic',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                      ));
                    } else {
                      teacherDataViewChildren.add(SizedBox.shrink());
                    }
                    return teacherDataViewChildren;
                  }(),
                )
              ])),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: () {
              List<Widget> lessonInfoWidgets = <Widget>[
                Row(children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16.0,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                      '${this.lesson.beginTime ?? '?'}-${this.lesson.endTime ?? '?'}',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0))
                ]),
              ];

              if (this.lesson.room != null) {
                lessonInfoWidgets.addAll([
                  SizedBox(height: 3.0),
                  Row(children: [
                    Icon(
                      Icons.room_rounded,
                      size: 16.0,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8.0),
                    Text('${this.lesson.room}',
                        style: TextStyle(color: Colors.grey, fontSize: 14.0))
                  ])
                ]);
              }

              if (this.lesson.campus != null) {
                lessonInfoWidgets.add(
                  SizedBox(height: 3.0),
                );
                lessonInfoWidgets.add(Row(children: [
                  Icon(
                    Icons.apartment_rounded,
                    size: 16.0,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8.0),
                  Text('${this.lesson.campus}',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0))
                ]));
              }

              return lessonInfoWidgets;
            }(),
          )
        ],
      ),
    );
  }
}
