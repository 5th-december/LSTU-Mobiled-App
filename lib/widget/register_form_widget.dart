import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lk_client/bloc/registration_bloc.dart';
import 'package:lk_client/event/register_event.dart';
import 'package:lk_client/model/response/business_logic_error.dart';
import 'package:lk_client/router_path.dart';
import 'package:lk_client/state/register_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class RegisterFormWidget extends StatefulWidget
{
  @override
  _RegisterFormWidgetState createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  String _emailErrorText;
  String _passwordErrorText;

  Stream _stateStream;

  @override 
  Widget build(BuildContext context) {
    RegistrationBloc registrationBloc = AppStateContainer.of(context).blocProvider.registrationBloc;

    Function formSubmitButton = () {
      return ElevatedButton(
        child: Text('Регистрация'),
        onPressed: () {
          setState(() => this._stateStream = registrationBloc.state);
          registrationBloc.eventController.sink.add(
            RegisterButtonPressedEvent(
              login: this._emailTextEditingController.text,
              password: this._passwordTextEditingController.text
            )
          );
        },
      );
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: this._formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Электронная почта',
                  errorText: this._emailErrorText
                ),
                controller: _emailTextEditingController
              ), 
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: this._passwordTextEditingController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  errorText: this._passwordErrorText
                )
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Повторите пароль'
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: StreamBuilder<RegisterState>(
                  stream: this._stateStream,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<RegisterState> registerStateSnapshot
                  ) {
                    if (registerStateSnapshot.hasError) {
                      return AlertDialog(
                        title: Text('Произошла непредвиденная ошибка. Перезапустите приложение'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => exit(1), 
                            child: Text('OK')
                          )
                        ],
                      );
                    }      

                    var connectionState = registerStateSnapshot.connectionState;
                    if (connectionState == ConnectionState.none) {
                      return formSubmitButton();
                    }
                    else if (connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        )
                      );
                    }
                    else if (connectionState == ConnectionState.active) {

                      if (!registerStateSnapshot.hasData) {
                        return null;
                      }

                      RegisterState state = registerStateSnapshot.data;
                      if (state is RegisterIdentifiedState) { 
                        Navigator.of(context).popAndPushNamed(RouterPathContainer.appHomePage);
                        return null;
                      }
                      else if (state is RegisterProcessingState) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          )
                        );
                      }
                      else if (state is RegisterErrorState) {
                        BusinessLogicError error = state.error;

                        setState(() {
                          if (error.errorProperties['email'] != null) {
                            this._emailErrorText = error.errorProperties['email'];
                          }
                          if (error.errorProperties['password'] != null) {
                            this._passwordErrorText = error.errorProperties['password'];
                          }
                        });

                      }

                    }
                    return null;
                  },
                )
              )
            ],
          ),
        )
      ],
    );
  }
}