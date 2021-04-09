import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/education/subject_list_bloc.dart';
import 'package:lk_client/event/content_event.dart';
import 'package:lk_client/event/request_command/education_request_command.dart';
import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/semester_entity.dart';
import 'package:lk_client/model/entity/subject_entity.dart';
import 'package:lk_client/page/subject_view_page.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class SubjectListPage extends StatefulWidget {
  final SemesterEntity _requiredSemester;
  final EducationEntity _requiredEducation;

  SubjectListPage(this._requiredEducation, this._requiredSemester);

  @override
  _SubjectListPageState createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  SemesterEntity get _requiredSemester => widget._requiredSemester;
  EducationEntity get _requiredEducation => widget._requiredEducation;

  SubjectListBloc _subjectListBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_subjectListBloc == null) {
      EducationQueryService queryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;
      this._subjectListBloc = SubjectListBloc(queryService);
    }
  }

  @override
  Widget build(BuildContext context) {
    this._subjectListBloc.eventController.sink.add(
        StartLoadingContentEvent<LoadSubjectListCommand>(
            LoadSubjectListCommand(_requiredEducation, _requiredSemester)));

    return Scaffold(
      appBar: AppBar(
        title: Text('Дисциплины'),
      ),
      body: StreamBuilder(
        stream: this._subjectListBloc.subjectListContentStateStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData &&
              snapshot.data is ContentReadyState<List<SubjectEntity>>) {
            List<SubjectEntity> loadedSubjects =
                (snapshot.data as ContentReadyState<List<SubjectEntity>>)
                    .content;

            return ListView.builder(
                itemCount: loadedSubjects.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: FlutterLogo(size: 50),
                      title: Text(loadedSubjects[index].subjectName),
                      subtitle: Text(loadedSubjects[index].chairName),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SubjectViewPage(loadedSubjects[index]);
                        }));
                      },
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
