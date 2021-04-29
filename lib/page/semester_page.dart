import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/education/semester_list_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/page/subject_list_page.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class SemesterPage extends StatefulWidget {
  final Person _person;
  final Education _education;

  SemesterPage(this._person, this._education);

  @override
  _SemesterPageState createState() => _SemesterPageState();
}

class _SemesterPageState extends State<SemesterPage> {
  SemesterListBloc _semesterListBloc;

  Person get _person => widget._person;
  Education get _education => widget._education;

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
  Widget build(BuildContext context) {
    this._semesterListBloc.eventController.sink.add(
        StartLoadingContentEvent<LoadSemsterListCommand>(
            LoadSemsterListCommand(this._person, this._education)));

    return Scaffold(
        appBar: AppBar(
          title: Text('Семестры'),
        ),
        body: StreamBuilder(
          stream: _semesterListBloc.semesterListStateStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData &&
                snapshot.data is ContentReadyState<List<Semester>>) {
              List<Semester> semestersList =
                  (snapshot.data as ContentReadyState<List<Semester>>)
                      .content;

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
                              return SubjectListPage(_education, semestersList[index]);
                            }));
                          },
                        ),
                      );
                    }),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
