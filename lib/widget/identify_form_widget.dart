import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lk_client/bloc/identification_bloc.dart';
import 'package:lk_client/event/identify_event.dart';
import 'package:lk_client/router_path.dart';
import 'package:lk_client/state/identify_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class UserIdentifyFormWidget extends StatefulWidget
{
  @override 
  _UserIdentifyFormWidgetState createState() => _UserIdentifyFormWidgetState();
}

class _UserIdentifyFormWidgetState extends State<UserIdentifyFormWidget>
{
  final _usernameEditingController = TextEditingController();
  final _zBookNumberEditingController = TextEditingController();
  final _enterYearEditingController = TextEditingController();

  Stream _stateStream;

  Widget _showAlertDialog(String message, Function action) {
    return AlertDialog(
      title: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: action, 
          child: Text('OK')
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context)
  {
    IdentificationBloc identificationBloc = AppStateContainer.of(context).blocProvider.identificationBloc;

    Function formSubmitButton = () {
      return ElevatedButton(
        onPressed: () {
          setState(() => this._stateStream = identificationBloc.state);
          identificationBloc.eventController.sink.add(IdentificationButtonPressedEvent(
            name: this._usernameEditingController.text,
            enterYear: int.parse(_enterYearEditingController.text),
            zBookNumber: this._zBookNumberEditingController.text
          ));
        },
        child: Text('Регистрация')
      );
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ФИО',
                    hintText: 'Иванов Иван Иванович'
                  ),
                  autofocus: true,
                  controller: _usernameEditingController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Номер зачетной книжки',
                    hintText: '12345678'
                  ),
                  controller: _zBookNumberEditingController,
                ), 
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Год поступления',
                    hintText: '2017'
                  ),
                  controller: _enterYearEditingController,
                ), 
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: StreamBuilder<IdentifyState>(
                    stream: this._stateStream,
                    builder: (
                      BuildContext context, 
                      AsyncSnapshot<IdentifyState> registerStateSnapshot
                    ) {
                      if (registerStateSnapshot.hasError) {
                        return this._showAlertDialog(
                          'Возникла неожиданная ошибка. Перезапустите приложение', 
                          () => exit(1)
                        );
                      }
                      
                      if (registerStateSnapshot.connectionState == ConnectionState.none) {
                        return formSubmitButton();
                      }
                      else if (registerStateSnapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          )
                        );
                      }
                      else if (registerStateSnapshot.connectionState == ConnectionState.active) {
                        if (!registerStateSnapshot.hasData) {
                          return null;
                        }
                        
                        var receivedState = registerStateSnapshot.data;
                        if (receivedState is IdentifyInitState) { 
                          Navigator.of(context).popAndPushNamed(RouterPathContainer.appRegisterPage);
                          return null;
                        }
                        else if(receivedState is IdentifyProcessingState) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            )
                          );
                        }
                        else if (receivedState is IdentifyErrorState) {
                          String errorMessage = receivedState.error.userMessage;
                          return Text(errorMessage);
                        }
                      }

                      return null;
                    }
                  )
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}