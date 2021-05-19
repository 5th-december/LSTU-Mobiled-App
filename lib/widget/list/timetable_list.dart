import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/education/timetable.dart';
import 'package:lk_client/model/education/timetable_day.dart';
import 'package:lk_client/model/education/timetable_item.dart';
import 'package:lk_client/model/education/timetable_week.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';

class TimetableList extends StatefulWidget
{
  final Education education;
  final Semester semester;
  final TimetableWeek week;

  TimetableList({
    Key key,
    @required this.education,
    @required this.semester,
    @required this.week
  }): super(key: key);

  @override
  _TimetableListState createState() => _TimetableListState();
}

class _TimetableListState extends State<TimetableList> with AutomaticKeepAliveClientMixin
{
  TimetableLoadingBloc _timetableLoadingBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._timetableLoadingBloc == null) {
      final educationQueryService = AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._timetableLoadingBloc = TimetableLoadingBloc(educationQueryService);
    }
  }

  @override
  Widget build(BuildContext context) {
    this._timetableLoadingBloc.eventController.add(StartConsumeEvent<LoadTimetableCommand>(
      request: LoadTimetableCommand(
        education: widget.education,
        weekType: widget.week,
        semester: widget.semester
      )
    ));

    return StreamBuilder(
      stream: this._timetableLoadingBloc.consumingStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          final state = (snapshot.data as ConsumingState<Timetable>);

          if(state is ConsumingErrorState<Timetable>) {
            return Center(child: Text('Ошибка загрузки расписания'));
          }

          if(state is ConsumingReadyState<Timetable>) {
            Timetable loadedTimetable = state.content;

            final timetableWeek = loadedTimetable.weeks.firstWhere((TimetableWeek week) => week.type == widget.week.type, orElse: () => null);

            if(timetableWeek == null) {
              return Center(child: Text('Запрошенная учебная неделя не найдена'));
            }

            List<TimetableDay> days = timetableWeek.days;

            return Padding(
              padding: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0, bottom: 15.0),
              child: ListView.separated(
                itemCount: days.length + 1,
                itemBuilder: (BuildContext context, int dayIndex) {
                  if(dayIndex == 0 || dayIndex == days.length + 1) {
                    return Container();
                  }
                  List<TimetableItem> lessons = days[dayIndex - 1].lessons;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: () {
                      List<Widget> dayLessonWidgets = <Widget>[];

                      for(int i = 0; i != lessons.length; ++i) {
                        dayLessonWidgets.add(
                          Container(
                            child: ListTile(
                              title: Text(lessons[i].discipline.name),
                              subtitle: Text(lessons[i]?.lessonType ?? ''),
                              trailing: Text(lessons[i]?.room ?? ''),
                            ),
                          )
                        );
                        if(i != lessons.length - 1) {
                          dayLessonWidgets.add(Divider());
                        }
                      }

                      return dayLessonWidgets;
                    }(),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 80.0,
                    width: double.infinity,
                    child: Center(
                      child: Text(days[index].name),
                    ),
                  );
                },
              ),
            );
          }
        }

        return CenteredLoader();
      },
    );
  }
}