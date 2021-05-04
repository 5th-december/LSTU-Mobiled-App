import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/bloc/login_bloc.dart';
import 'package:lk_client/event/login_event.dart';
import 'package:lk_client/model/authentication/login_credentials.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/state/login_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';

class LoginForm extends StatefulWidget {
  final AuthorizationService _authorizationService;

  LoginForm(this._authorizationService);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _stateKey = GlobalKey<FormState>();

  final _usernameEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();

  String _usernameErrorText;
  String _passwordErrorText;

  LoginBloc _loginBloc;

  AuthorizationService get authorizationService => widget._authorizationService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._loginBloc == null) {
      AuthenticationBloc authenticationBloc =
          AppStateContainer.of(context).blocProvider.authenticationBloc;
      this._loginBloc = LoginBloc(authorizationService, authenticationBloc);
    }
  }

  @override
  dispose() async {
    Future.delayed(Duration.zero, () async {
      await this._loginBloc.dispose();
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
                controller: _usernameEditingController,
                decoration: InputDecoration(
                    labelText: 'Имя пользователя',
                    errorText: this._usernameErrorText),
              ),
              TextFormField(
                  controller: _passwordEditingController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                      labelText: 'Пароль', errorText: this._passwordErrorText)),
              Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: StreamBuilder<LoginState>(
                      stream: this._loginBloc.state,
                      builder: (BuildContext context,
                          AsyncSnapshot<LoginState> loginStateSnapshot) {
                        if (loginStateSnapshot.connectionState ==
                            ConnectionState.active) {
                          LoginState receivedLoginState =
                              loginStateSnapshot.data;
                          if (receivedLoginState is LoginErrorState) {
                            _onWidgetDidBuild(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${receivedLoginState.error}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                          } else if (receivedLoginState
                              is LoginProcessingState) {
                            return Container(
                                child: Center(
                              child: CircularProgressIndicator(),
                            ));
                          }
                        }

                        return ElevatedButton(
                            child: Text('Вход'),
                            onPressed: () {
                              LoginCredentials loginCredentials =
                                  LoginCredentials(
                                      login:
                                          this._usernameEditingController.text,
                                      password:
                                          this._passwordEditingController.text);

                              LoginButtonPressedEvent userLoginEvent =
                                  LoginButtonPressedEvent(
                                      userLoginCredentials: loginCredentials);
                              this
                                  ._loginBloc
                                  .eventController
                                  .add(userLoginEvent);
                            });
                      }))
            ],
          ),
        )
      ],
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
