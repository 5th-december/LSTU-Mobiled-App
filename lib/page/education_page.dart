import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/widget/education_list.dart';

class EducationPage extends StatefulWidget {
  final Person _currentPerson;
  final bool _allowToSelectByDefault;
  final Function _navigateToNextPage;

  EducationPage(this._currentPerson, this._allowToSelectByDefault, this._navigateToNextPage);

  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Обучение'),
      ),
      body: EducationList(widget._currentPerson, widget._allowToSelectByDefault, widget._navigateToNextPage)
    );
  }
}
