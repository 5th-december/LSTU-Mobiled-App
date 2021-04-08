import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/education_list_bloc.dart';
import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
import 'package:lk_client/store/app_state_container.dart';

class SemesterPage extends StatefulWidget {
  final PersonEntity _person;
  final EducationEntity _education;

  SemesterPage(this._person, this._education);

  @override
  _SemesterPageState createState() => _SemesterPageState();
}

class _SemesterPageState extends State<SemesterPage> {
  EducationListBloc _educationListBloc;

  PersonEntity get _person => widget._person;
  EducationEntity get _education => widget._education;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._educationListBloc == null) {
      EducationQueryService queryService =
          AppStateContainer.of(context).serviceProvider.educationQueryService;

      this._educationListBloc = EducationListBloc(queryService);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Семестр'),
      ),
      body: null,
    );
  }
}
