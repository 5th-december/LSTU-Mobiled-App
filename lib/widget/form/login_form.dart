import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/bloc/authentication/login_bloc.dart';
import 'package:lk_client/error_handler/authentication_error_handler.dart';
import 'package:lk_client/event/login_event.dart';
import 'package:lk_client/model/authentication/login_credentials.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/state/login_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/form/semitransparent_text_form_field.dart';

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
      final serviceProvider = AppStateContainer.of(context).serviceProvider;
      AuthenticationBloc authenticationBloc =
          AppStateContainer.of(context).blocProvider.authenticationBloc;
      this._loginBloc = LoginBloc(
          authorizationService: authorizationService,
          authenticationBloc: authenticationBloc,
          fcmService: serviceProvider.firebaseMessaging,
          utilQueryService: serviceProvider.utilQueryService);
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
              SemitransparentTextFormField(
                controller: _usernameEditingController,
                hintText: 'Имя пользователя',
                icon: Icons.person_rounded,
                errorText: this._usernameErrorText,
                autofocus: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              SemitransparentTextFormField(
                controller: _passwordEditingController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                hintText: 'Пароль',
                errorText: this._passwordErrorText,
                icon: Icons.lock_rounded,
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: StreamBuilder<LoginState>(
                      stream: this._loginBloc.state,
                      builder: (BuildContext context,
                          AsyncSnapshot<LoginState> loginStateSnapshot) {
                        final loginChildWidgets = <Widget>[];
                        if (loginStateSnapshot.connectionState ==
                            ConnectionState.active) {
                          LoginState receivedLoginState =
                              loginStateSnapshot.data;

                          if (receivedLoginState is LoginProcessingState) {
                            return Container(
                                child: Center(
                              child: CircularProgressIndicator(),
                            ));
                          }

                          if (receivedLoginState is LoginErrorState) {
                            final error = receivedLoginState.error;

                            loginChildWidgets.add(Text(
                              error is AuthenticationException
                                  ? 'Неверные учетные данные'
                                  : 'Ошибка авторизации',
                              style: Theme.of(context).textTheme.subtitle2,
                            ));
                          }
                        }

                        loginChildWidgets.add(Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: ElevatedButton(
                                key: UniqueKey(),
                                child: Text('Вход'),
                                onPressed: () {
                                  bool valid = true;

                                  setState(() {
                                    String username =
                                        this._usernameEditingController.text;
                                    RegExp usernameRegex = RegExp(
                                        r'^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$');
                                    String password =
                                        this._passwordEditingController.text;
                                    this._usernameErrorText = null;
                                    if (username == '') {
                                      this._usernameErrorText =
                                          'Заполните имя пользователя';
                                      valid = false;
                                    } else if (!usernameRegex
                                        .hasMatch(username)) {
                                      this._usernameErrorText =
                                          'Неверный формат имени пользователя';
                                      valid = false;
                                    }

                                    this._passwordErrorText = null;

                                    if (password == '') {
                                      this._passwordErrorText =
                                          'Введите пароль';
                                      valid = false;
                                    } else if (password.length < 6) {
                                      this._passwordErrorText =
                                          'Неверный формат пароля';
                                      valid = false;
                                    }
                                  });

                                  if (!valid) {
                                    return;
                                  }
                                  LoginCredentials loginCredentials =
                                      LoginCredentials(
                                          login: this
                                              ._usernameEditingController
                                              .text,
                                          password: this
                                              ._passwordEditingController
                                              .text);

                                  LoginButtonPressedEvent userLoginEvent =
                                      LoginButtonPressedEvent(
                                          userLoginCredentials:
                                              loginCredentials);
                                  this
                                      ._loginBloc
                                      .eventController
                                      .add(userLoginEvent);
                                })));

                        return Column(
                          children: loginChildWidgets,
                        );
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
