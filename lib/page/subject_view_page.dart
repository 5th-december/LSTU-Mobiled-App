import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/store/global/app_state_container.dart';

class SubjectViewPage extends StatefulWidget {
  Discipline _currentSubject;

  SubjectViewPage(this._currentSubject);

  @override
  _SubjectViewPageState createState() => _SubjectViewPageState();
}

class _SubjectViewPageState extends State<SubjectViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Дисциплина'),
      ),
      body: StreamBuilder(
        stream:
            AppStateContainer.of(context).blocProvider.authenticationBloc.state,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.toString());
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
