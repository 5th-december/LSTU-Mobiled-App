import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/semester_list_bloc.dart';
import 'package:lk_client/command/consume_command/education_request_command.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';

class SemesterList extends StatefulWidget {
  final Education _education;
  final Function _navigateToNextPage;

  SemesterList(this._education, this._navigateToNextPage);

  @override
  _SemesterListState createState() => _SemesterListState();
}

class _SemesterListState extends State<SemesterList> {
  SemesterListBloc _semesterListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._semesterListBloc == null) {
      EducationQueryService queryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;

      this._semesterListBloc = SemesterListBloc(queryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._semesterListBloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._semesterListBloc.eventController.sink.add(
        StartLoadingContentEvent<LoadSemsterListCommand>(
            LoadSemsterListCommand(widget._education)));

    return StreamBuilder(
        stream: _semesterListBloc.semesterListStateStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is ContentReadyState<List<Semester>>) {
              List<Semester> semestersList =
                  (snapshot.data as ContentReadyState<List<Semester>>).content;

              return Container(
                child: ListView.builder(
                    itemCount: semestersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: FlutterLogo(
                            size: 50,
                          ),
                          title: Text(
                              "${semestersList[index].season} ${semestersList[index].year}"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return widget
                                  ._navigateToNextPage(semestersList[index]);
                            }));
                          },
                        ),
                      );
                    }),
              );
            }
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
