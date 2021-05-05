import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/education/timetable_day.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/education/timetable_week.dart';

class CardTimetableWeek extends StatelessWidget
{
  final TimetableWeek week;
  final bool showDiscipline;
  final bool showLessonType;
  final bool showGroups;

  CardTimetableWeek({
    Key key, 
    @required this.week, 
    this.showDiscipline = true,
    this.showLessonType = true,
    this.showGroups = true
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: this.week.days.map((TimetableDay day) => this.getDayView(day)).toList()
      ),
    );
  }

  Widget getDayView(TimetableDay day) {
    List<Widget> columnChild = [
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              child: Text(day.name),
            )
          )
        ],
      ),
    ];

    columnChild.addAll(day.lessons.map((TimetableItem lesson) => 
      this.getLessonView(lesson)).toList());

    return Container(
      child: Column(
        children: columnChild,
      ),
    );
  }

  Widget getLessonView(TimetableItem lesson) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(1, 76, 207, 224),
                borderRadius: BorderRadius.circular(2.0)
              ),
              padding: EdgeInsets.all(3.0),
              child: Text(lesson.beginTime),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(1, 236, 0, 140),
                  borderRadius: BorderRadius.circular(2.0)
                ),
                padding: EdgeInsets.all(3.0),
                child: Text(lesson.beginTime),
              ),
            )
          ],
        ),
        Expanded(
          child: Column(
            children: () {
              List<Widget> lessonInfo = [];
              if(this.showDiscipline) {
                lessonInfo.add(Text(lesson.discipline.name));
              }
              if(this.showLessonType) {
                lessonInfo.add(Text(lesson.lessonType));
              }
            }(),
          )
        )
      ],
    );
  }
}