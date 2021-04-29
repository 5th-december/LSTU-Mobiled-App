import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/widget/personal/education_details_widget.dart';
import 'package:lk_client/widget/personal/personal_information_widget.dart';

class PersonalPage extends StatefulWidget {
  final Person _person;

  PersonalPage(this._person);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  Person get _person => widget._person;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Персональная страница'),
      ),
      body: Column(
        children: [
          PersonalInformationWidget(_person),
          EducationDetailsWidget(_person)
        ],
      ),
    );
  }
}
