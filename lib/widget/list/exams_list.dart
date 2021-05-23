import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/exam.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/state/consuming_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/centered_loader.dart';

class ExamsList extends StatefulWidget {
  final Education education;
  final Semester semester;

  ExamsList({Key key, @required this.education, @required this.semester})
      : super(key: key);

  @override
  _ExamsListState createState() => _ExamsListState();
}

class _ExamsListState extends State<ExamsList>
    with AutomaticKeepAliveClientMixin {
  ExamsTimetableLoadingBloc _bloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      final appEducationQueryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._bloc = ExamsTimetableLoadingBloc(appEducationQueryService);
    }
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.add(StartConsumeEvent<LoadExamsTimetableCommand>(
        request: LoadExamsTimetableCommand(
            semester: widget.semester, education: widget.education)));

    return StreamBuilder(
        stream: this._bloc.consumingStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final state = snapshot.data as ConsumingState<List<Exam>>;

            if (state is ConsumingErrorState<List<Exam>>) {
              return Center(child: Text('Ошибка загрузки списка экзаменов'));
            }

            if (state is ConsumingReadyState<List<Exam>>) {
              List<Exam> examList = state.content;

              if (examList.length == 0) {
                return Center(child: Text('Экзамены пока не запланированы'));
              }

              return Padding(
                padding: EdgeInsets.only(
                    top: 20.0, left: 12.0, right: 12.0, bottom: 15.0),
                child: ListView.separated(
                  itemCount: examList.length,
                  itemBuilder: (BuildContext context, int index) {
                    DateFormat formatter = DateFormat('dd.MM.yyyy hh:mm');
                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            examList[index].discipline.name,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Row(children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 16.0,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8.0),
                            Text(formatter.format(examList[index].examTime),
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                            SizedBox(width: 16.0),
                            Icon(
                              Icons.location_on_rounded,
                              size: 16.0,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8.0),
                            Text(examList[index].room,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                            SizedBox(width: 16.0),
                            Icon(
                              Icons.person_rounded,
                              size: 16.0,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8.0),
                            Text(examList[index].teacherName,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                          ])
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 4.0),
                ),
              );
            }
          }
          return CenteredLoader();
        });
  }
}
