import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/education/timetable_week.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/widget/list/exams_list.dart';
import 'package:lk_client/widget/list/timetable_list.dart';

class TimetablePage extends StatefulWidget {
  final Education education;
  final Semester semester;
  final List<Widget> timetableSelectorList;

  TimetablePage(
      {Key key,
      @required this.education,
      @required this.semester,
      this.timetableSelectorList})
      : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Расписание'),
          actions: widget.timetableSelectorList,
          bottom: TabBar(
            controller: this._tabController,
            tabs: [
              Tab(icon: Text('Белая')),
              Tab(icon: Text('Зеленая')),
              Tab(icon: Text('Экзамены')),
            ],
          ),
        ),
        body: TabBarView(controller: this._tabController, children: [
          TimetableList(
            education: widget.education,
            semester: widget.semester,
            week: TimetableWeek(type: 'white'),
          ),
          TimetableList(
            education: widget.education,
            semester: widget.semester,
            week: TimetableWeek(type: 'green'),
          ),
          ExamsList(education: widget.education, semester: widget.semester)
        ]));
  }
}
