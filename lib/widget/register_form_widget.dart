import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/bloc/registration_bloc.dart';
import 'package:lk_client/event/register_event.dart';
import 'package:lk_client/router_path.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/register_state.dart';
import 'package:lk_client/store/app_state_container.dart';

class RegisterFormWidget extends StatefulWidget {
  AuthorizationService _authorizationService;

  RegisterFormWidget(this._authorizationService);

  @override
  _RegisterFormWidgetState createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final GlobalKey<FormState> _stateKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  RegistrationBloc _registrationBloc;

  String _emailErrorText;
  String _passwordErrorText;

  AuthorizationService get authorizationService => widget._authorizationService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._registrationBloc == null) {
      AuthenticationBloc authenticationBloc =
          AppStateContainer.of(context).blocProvider.authenticationBloc;
      this._registrationBloc =
          RegistrationBloc(authorizationService, authenticationBloc);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._registrationBloc.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: this._stateKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Электронная почта',
                      errorText: this._emailErrorText),
                  controller: _emailTextEditingController),
              TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: this._passwordTextEditingController,
                  decoration: InputDecoration(
                      labelText: 'Пароль', errorText: this._passwordErrorText)),
              TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(labelText: 'Повторите пароль')),
              Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: StreamBuilder<RegisterState>(
                    stream: this._registrationBloc.state,
                    builder: (BuildContext context,
                        AsyncSnapshot<RegisterState> registerStateSnapshot) {
                      if (registerStateSnapshot.connectionState ==
                          ConnectionState.active) {
                        RegisterState state = registerStateSnapshot.data;

                        if (state is RegisterProcessingState) {
                          return Container(
                              child: Center(
                            child: CircularProgressIndicator(),
                          ));
                        } else if (state is RegisterErrorState) {
                          setState(() {
                            // exception handling
                          });
                        }
                      }

                      return ElevatedButton(
                        child: Text('Регистрация'),
                        onPressed: () {
                          _registrationBloc.eventController.sink.add(
                              RegisterButtonPressedEvent(
                                  login: this._emailTextEditingController.text,
                                  password: this
                                      ._passwordTextEditingController
                                      .text));
                        },
                      );
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }
}
