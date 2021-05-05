import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/loader_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/consuming_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/stream_loading_widget.dart';

class DisciplineList extends StatefulWidget {
  final Semester semester;
  final Education education;
  final Function onItemTap;

  DisciplineList(
      {Key key,
      @required this.education,
      @required this.semester,
      this.onItemTap})
      : super(key: key);

  @override
  _DisciplineListState createState() => _DisciplineListState();
}

class _DisciplineListState extends State<DisciplineList> {
  SubjectListLoadingBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      EducationQueryService queryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._bloc = SubjectListLoadingBloc(queryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._bloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(
        StartConsumeEvent<LoadSubjectListCommand>(
            request:
                LoadSubjectListCommand(widget.education, widget.semester)));

    return StreamLoadingWidget<List<Discipline>>(
      loadingStream: this._bloc.consumingStateStream,
      childBuilder: (List<Discipline> argumentList) {
        return ListView.builder(
            itemCount: argumentList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                    leading: FlutterLogo(size: 36.0),
                    title: Text(argumentList[index].name),
                    onTap: () => widget.onItemTap(argumentList[index])),
              );
            });
      },
    );
  }
}
