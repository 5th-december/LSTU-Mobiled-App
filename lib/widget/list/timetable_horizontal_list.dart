import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/education/timetable.dart';
import 'package:lk_client/model/education/timetable_week.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/card_timetable_week.dart';
import 'package:lk_client/widget/chunk/stream_loading_widget.dart';

class TimetableHorizontalList extends StatefulWidget {
  final Discipline discipline;
  final Education education;
  final Semester semester;

  TimetableHorizontalList(
      {Key key,
      @required this.discipline,
      @required this.semester,
      @required this.education})
      : super(key: key);

  @override
  _TimetableHorizontalListState createState() =>
      _TimetableHorizontalListState();
}

class _TimetableHorizontalListState extends State<TimetableHorizontalList> {
  DisciplineTimetableLoadingBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      DisciplineQueryService queryService =
          AppStateContainer.of(context).serviceProvider.disciplineQueryService;
      this._bloc = DisciplineTimetableLoadingBloc(queryService);
    }
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(
        StartConsumeEvent<LoadDisciplineTimetable>(
            request: LoadDisciplineTimetable(
                discipline: widget.discipline,
                education: widget.education,
                semester: widget.semester)));

    return StreamLoadingWidget<Timetable>(
      loadingStream: this._bloc.consumingStateStream,
      childBuilder: (Timetable timetable) {
        return Container(
            padding: EdgeInsets.only(top: 12.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: timetable.weeks
                      .map((TimetableWeek week) => CardTimetableWeek(
                            week: week,
                            isSingle: timetable.weeks.length == 1,
                          ))
                      .toList(),
                ))));
      },
    );
  }
}
