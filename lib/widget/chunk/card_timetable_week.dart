import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/education/timetable_day.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/education/timetable_week.dart';

class CardTimetableWeek extends StatelessWidget {
  final TimetableWeek week;
  final bool showDiscipline;
  final bool showLessonType;
  final bool showGroups;
  final bool isSingle;

  CardTimetableWeek(
      {Key key,
      @required this.week,
      this.isSingle = true,
      this.showDiscipline = true,
      this.showLessonType = true,
      this.showGroups = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth =
        MediaQuery.of(context).size.width - (this.isSingle ? 24 : 48);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5.0),
        child: Container(
          constraints: BoxConstraints(
            minWidth: cardWidth,
            maxWidth: cardWidth,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2.0,
                  blurRadius: 2.0,
                )
              ]),
          padding: EdgeInsets.all(12.0),
          child: Column(
              children: this
                  .week
                  .days
                  .map((TimetableDay day) => this.getDayView(day))
                  .toList()),
        ));
  }

  Widget getDayView(TimetableDay day) {
    List<Widget> columnChild = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: Text(day.name),
          )
        ],
      )
    ];

    columnChild.addAll(day.lessons
        .map((TimetableItem lesson) => this.getLessonView(lesson))
        .toList());

    return Row(children: [
      Expanded(
          child: Column(
        children: columnChild,
      )),
    ]);
  }

  Widget getLessonView(TimetableItem lesson) {
    return Padding(
        padding: EdgeInsets.only(bottom: 5.0),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(1, 76, 207, 224),
                      borderRadius: BorderRadius.circular(2.0)),
                  //padding: EdgeInsets.all(3.0),
                  child: Text(lesson.beginTime),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(1, 236, 0, 140),
                        borderRadius: BorderRadius.circular(2.0)),
                    //padding: EdgeInsets.all(3.0),
                    child: Text(lesson.endTime),
                  ),
                )
              ],
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: () {
                        List<Widget> lessonInfo = [];
                        if (this.showDiscipline) {
                          lessonInfo.add(Text(lesson.discipline.name));
                        }
                        if (this.showLessonType) {
                          lessonInfo.add(Text(lesson.lessonType));
                        }
                        return lessonInfo;
                      }(),
                    )))
          ],
        ));
  }
}
