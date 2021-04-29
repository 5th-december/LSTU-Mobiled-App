import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/education/education_list_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/page/semester_page.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class EducationPage extends StatefulWidget {
  Person _currentPerson;

  EducationPage(this._currentPerson);

  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  EducationListBloc _educationBloc;

  Person get _currentPerson => widget._currentPerson;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._educationBloc == null) {
      EducationQueryService queryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._educationBloc = EducationListBloc(queryService);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._educationBloc.dispose();
    });
    super.dispose();
  }

  Widget build(BuildContext context) {
    this._educationBloc.eventController.sink.add(
        StartLoadingContentEvent<LoadUserEducationListCommand>(
            LoadUserEducationListCommand(this._currentPerson)));

    return Scaffold(
      appBar: AppBar(
        title: Text('Обучение'),
      ),
      body: StreamBuilder(
        stream: this._educationBloc.educationListStateStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData &&
              snapshot.data is ContentReadyState<List<Education>>) {
            List<Education> educationsList =
                (snapshot.data as ContentReadyState<List<Education>>)
                    .content;

            return Container(
                child: ListView.builder(
                    itemCount: educationsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: FlutterLogo(
                            size: 50,
                          ),
                          title: Text(educationsList[index].group.speciality.specName),
                          subtitle: Text(educationsList[index].group.speciality.qualification),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return SemesterPage(
                                  this._currentPerson, educationsList[index]);
                            }));
                          },
                        ),
                      );
                    }));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
