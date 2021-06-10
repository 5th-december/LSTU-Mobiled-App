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
                  spreadRadius: 1.0,
                  blurRadius: 2.0,
                )
              ]),
          padding: EdgeInsets.all(12.0),
          child: Column(
              children: this
                  .week
                  .days
                  .map((TimetableDay day) => this.getDayView(context, day))
                  .toList()),
        ));
  }

  Widget getDayView(BuildContext context, TimetableDay day) {
    List<Widget> columnChild = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            child: Text(
              day.name,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          )
        ],
      ),
      SizedBox(
        height: 3.0,
      )
    ];

    columnChild.addAll(day.lessons
        .map((TimetableItem lesson) => this.getLessonView(context, lesson))
        .toList());

    return Row(children: [
      Expanded(
          child: Column(
        children: columnChild,
      )),
    ]);
  }

  Widget getLessonView(BuildContext context, TimetableItem lesson) {
    return Padding(
        padding: EdgeInsets.only(bottom: 5.0),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(243, 243, 243, 1.0),
                      borderRadius: BorderRadius.circular(2.0)),
                  padding: EdgeInsets.all(3.0),
                  child: Text(
                    lesson.beginTime,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 243, 243, 1.0),
                        borderRadius: BorderRadius.circular(2.0)),
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      lesson.endTime,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
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
                          lessonInfo.add(Text(lesson.discipline.name,
                              style: Theme.of(context).textTheme.bodyText1));
                        }
                        if (this.showLessonType) {
                          lessonInfo.add(SizedBox(
                            height: 4.0,
                          ));
                          lessonInfo.add(Text(lesson.lessonType,
                              style: Theme.of(context).textTheme.bodyText2));
                        }
                        return lessonInfo;
                      }(),
                    )))
          ],
        ));
  }
}
