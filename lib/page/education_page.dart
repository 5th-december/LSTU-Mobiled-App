import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/bloc/education_list_bloc.dart';
import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
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
      AuthenticationBloc appAuthenticator =
          AppStateContainer.of(context).blocProvider.authenticationBloc;
      this._educationBloc =
          new EducationListBloc(appAuthenticator, queryService);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Supercool'),
      ),
      body: StreamBuilder(
        stream: this._educationBloc.state,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          
        },
      ),
    );
  }
}
