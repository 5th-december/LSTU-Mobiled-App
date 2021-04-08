import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/education_list_bloc.dart';
import 'package:lk_client/bloc/semester_list_bloc.dart';
import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/model/entity/semester_entity.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
import 'package:lk_client/state/content_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class SemesterPage extends StatefulWidget {
  final PersonEntity _person;
  final EducationEntity _education;

  SemesterPage(this._person, this._education);

  @override
  _SemesterPageState createState() => _SemesterPageState();
}

class _SemesterPageState extends State<SemesterPage> {
  SemesterListBloc _semesterListBloc;

  PersonEntity get _person => widget._person;
  EducationEntity get _education => widget._education;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Семестры'),
      ),
      body: StreamBuilder(
        stream: _semesterListBloc.semesterListStateStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData && snapshot.data is ContentReadyState<List<SemesterEntity>>) {
            List<SemesterEntity> semestersList = (snapshot.data as ContentReadyState<List<SemesterEntity>>).content;

            return Container(
              child: ListView.builder(
                itemCount: semestersList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: FlutterLogo(
                        size: 50,
                      ),
                      title: Text("${semestersList[index].season} ${semestersList[index].year}"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return null;
                          }
                        ));
                      },
                    ),
                  );
                }
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}
