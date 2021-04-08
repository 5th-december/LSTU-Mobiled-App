import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/education_list_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/page/semester_page.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class EducationPage extends StatefulWidget {
  PersonEntity _currentPerson;

  EducationPage(this._currentPerson);

  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  EducationListBloc _educationBloc;

  PersonEntity get _currentPerson => widget._currentPerson;

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
              snapshot.data is ContentReadyState<List<EducationEntity>>) {
            List<EducationEntity> educationsList =
                (snapshot.data as ContentReadyState<List<EducationEntity>>)
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
                          title: Text(educationsList[index].name),
                          subtitle: Text(educationsList[index].qualification),
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
