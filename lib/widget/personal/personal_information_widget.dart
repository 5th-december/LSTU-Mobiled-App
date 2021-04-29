import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/person/person.dart';

class PersonalInformationWidget extends StatelessWidget {
  final Person _person;

  PersonalInformationWidget(this._person);

  Widget _buildInfoView(Person person) {
    List<Widget> personProperties = [];

    if (person.sex != null) {
      personProperties.add(_buildPropertyView('Пол', person.sex));
    }

    if (person.birthday != null) {
      personProperties
          .add(_buildPropertyView('Дата рождения', person.birthday.toString()));
    }

    if (person.phone != null) {
      personProperties.add(_buildPropertyView('Телефон', person.phone));
    }

    if (person.email != null) {
      personProperties.add(_buildPropertyView('Email', person.email));
    }

    if (person.messenger != null) {
      personProperties.add(_buildPropertyView('Мессенджер', person.messenger));
    }

    if (personProperties.length == 0) {
      // TODO: implement
      throw Exception('Not implemented');
    } else {
      List<Widget> colProperties = [Divider()];
      colProperties += personProperties;
      colProperties.add(Divider());

      return Column(
        children: colProperties,
      );
    }
  }

  Widget _buildPropertyView(String name, String property) {
    return Row(
      children: [Text('$name: $property')],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildInfoView(this._person)],
    );
  }
}
