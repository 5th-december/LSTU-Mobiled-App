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

class ExamsList extends StatefulWidget 
{
  final Education education;
  final Semester semester;

  ExamsList({
    Key key,
    @required this.education,
    @required this.semester
  }): super(key: key);

  @override
  _ExamsListState createState() => _ExamsListState();
}

class _ExamsListState extends State<ExamsList> with AutomaticKeepAliveClientMixin
{
  ExamsTimetableLoadingBloc _bloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._bloc == null) {
      final appEducationQueryService = AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._bloc = ExamsTimetableLoadingBloc(appEducationQueryService);
    }
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.add(StartConsumeEvent<LoadExamsTimetableCommand>(
      request: LoadExamsTimetableCommand(semester: widget.semester, education: widget.education)));

    return StreamBuilder(
      stream: this._bloc.consumingStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          final state = snapshot.data as ConsumingState<List<Exam>>;

          if(state is ConsumingErrorState<List<Exam>>) {
            return Center(child: Text('Ошибка загрузки списка экзаменов'));
          }

          if(state is ConsumingReadyState<List<Exam>>) {
            List<Exam> examList = state.content;

            if(examList.length == 0) {
              return Center(child: Text('Экзамены пока не запланированы'));
            }

            return Padding(
              padding: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0, bottom: 15.0),
              child: ListView.separated(
                itemCount: examList.length,
                itemBuilder: (BuildContext context, int index) {
                  DateFormat formatter = DateFormat('dd.MM.yyyy hh:mm');
                  return Container(
                    child: ListTile(
                      title: Text(examList[index].discipline.name),
                      subtitle: Text(formatter.format(examList[index].examTime)),
                    ),
                  );
                }, 
                separatorBuilder: (BuildContext context, int index) => Divider(), 
              ),
            );
          }
        }
        return CenteredLoader();
      }
    );
  }
}