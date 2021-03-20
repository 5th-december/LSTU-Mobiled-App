import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lk_client/bloc/login_bloc.dart';
import 'package:lk_client/event/login_event.dart';
import 'package:lk_client/model/request/user_login_credentials.dart';
import 'package:lk_client/router_path.dart';
import 'package:lk_client/state/login_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class LoginFormWidget extends StatefulWidget
{
  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> 
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  String _usernameErrorText;
  String _passwordErrorText;

  Stream stateStream;

  Widget showAlertDialog(String message, Function action) {
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
  Widget build(BuildContext context) {
    LoginBloc loginBloc = AppStateContainer.of(context).blocProvider.loginBloc;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: this._formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameEditingController,
                decoration: InputDecoration(
                  labelText: 'Имя пользователя',
                  errorText: this._usernameErrorText
                ),
              ),
              TextFormField(
                controller: _passwordEditingController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  errorText: this._passwordErrorText
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: StreamBuilder<LoginState> (
                  stream: stateStream,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<LoginState> loginStateSnapshot
                  ) {
                    if (loginStateSnapshot.hasError) {
                      return this.showAlertDialog(
                        'Возникла неожиданная ошибка. Перезапустите приложение', 
                        () => exit(1)
                      );
                    }

                    var connectionState = loginStateSnapshot.connectionState;
                    if (connectionState == ConnectionState.none) {
                      return ElevatedButton(
                        child: Text('Вход'),
                        onPressed: () {
                          setState(() => stateStream = loginBloc.state);
                          UserLoginCredentials loginCredentials = UserLoginCredentials(
                            login: this._usernameEditingController.text,
                            password: this._passwordEditingController.text
                          );
                          LoginButtonPressedEvent userLoginEvent = LoginButtonPressedEvent(
                            userLoginCredentials: loginCredentials
                          );
                          loginBloc.eventController.add(userLoginEvent);
                        }
                      );
                    }
                    else if (connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        )
                      );
                    }
                    else if (connectionState == ConnectionState.active) {
                      if (loginStateSnapshot.hasData) {
                        LoginState receivedLoginState = loginStateSnapshot.data;

                        if (receivedLoginState is LoginInitState) {
                            Navigator.of(context).popAndPushNamed(RouterPathContainer.appHomePage);
                        }
                        else if (receivedLoginState is LoginErrorState) {
                          String error = receivedLoginState.error.userMessage;
                          return this.showAlertDialog(error, null);
                        }
                        else if (receivedLoginState is LoginProcessingState) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            )
                          );
                        }
                      }
                    }

                    return null;
                  }
                )
              )
            ],
          ),
        )
      ],
    );
  }

  @override 
  void dispose() {
    this._passwordEditingController.dispose();
    this._usernameEditingController.dispose();
    super.dispose();
  }
}