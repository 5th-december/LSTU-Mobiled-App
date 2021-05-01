import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/person/person.dart';

class PersonalDataEditModal extends StatefulWidget {
  Person _editablePerson;
  BuildContext _outerContext;

  PersonalDataEditModal(this._editablePerson, this._outerContext);
  @override
  _PersonalDataEditModelState createState() => _PersonalDataEditModelState();
}

class _PersonalDataEditModelState extends State<PersonalDataEditModal> {
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  final _phoneEditingController = TextEditingController();
  final _emailEditionController = TextEditingController();
  final _messengerEditionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          constraints: BoxConstraints(maxHeight: 350.0),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Изменение данных профиля'),
                Form(
                  key: _editFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Телефон',
                          errorText: '',
                        ),
                        controller: _phoneEditingController,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          errorText: '',
                        ),
                        controller: _emailEditionController,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Мессенджер',
                          errorText: '',
                        ),
                        controller: _messengerEditionController,
                      )
                    ],
                  ),
                ),
                ElevatedButton(onPressed: () => 1, child: Text('Сохранить'))
              ],
            ),
          ),
        ));
  }
}
