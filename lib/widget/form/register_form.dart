import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication/registration_bloc.dart';
import 'package:lk_client/error_handler/api_system_error_handler.dart';
import 'package:lk_client/error_handler/authentication_error_handler.dart';
import 'package:lk_client/event/register_event.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/state/register_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/chunk/form/semitransparent_text_form_field.dart';

class RegisterForm extends StatefulWidget {
  final AuthorizationService _authorizationService;

  RegisterForm(this._authorizationService);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _stateKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _duplicatePasswordEditingController = TextEditingController();

  RegistrationBloc _registrationBloc;

  String _emailErrorText;
  String _passwordErrorText;
  String _duplicatePasswordErrorText;

  AuthorizationService get authorizationService => widget._authorizationService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._registrationBloc == null) {
      final authenticationBloc =
          AppStateContainer.of(context).blocProvider.authenticationBloc;
      final serviceProvider = AppStateContainer.of(context).serviceProvider;
      this._registrationBloc = RegistrationBloc(
          authorizationService: authorizationService,
          fcmService: serviceProvider.firebaseMessaging,
          utilQueryService: serviceProvider.utilQueryService,
          authenticationBloc: authenticationBloc);
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
              SemitransparentTextFormField(
                hintText: 'Электронная почта',
                errorText: this._emailErrorText,
                controller: _emailTextEditingController,
                icon: Icons.email_rounded,
              ),
              SizedBox(
                height: 20.0,
              ),
              SemitransparentTextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: this._passwordTextEditingController,
                  hintText: 'Пароль',
                  errorText: this._passwordErrorText,
                  icon: Icons.lock_rounded),
              SizedBox(
                height: 20.0,
              ),
              SemitransparentTextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: this._duplicatePasswordEditingController,
                errorText: this._duplicatePasswordErrorText,
                hintText: 'Повторите пароль',
                icon: Icons.enhanced_encryption_rounded,
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: StreamBuilder<RegisterState>(
                    stream: this._registrationBloc.state,
                    builder: (BuildContext context,
                        AsyncSnapshot<RegisterState> registerStateSnapshot) {
                      final registerChildWidgets = <Widget>[];

                      if (registerStateSnapshot.connectionState ==
                          ConnectionState.active) {
                        RegisterState state = registerStateSnapshot.data;

                        if (state is RegisterProcessingState) {
                          return Container(
                              child: Center(
                            child: CircularProgressIndicator(),
                          ));
                        } else if (state is RegisterErrorState) {
                          final error = state.error;
                          registerChildWidgets.add(Text(
                            () {
                              if (error is AuthenticationException) {
                                return 'Ошибка регистрации';
                              } else if (error is ApiSystemException) {
                                return 'Внутренняя ошибка сервиса';
                              } else {
                                return 'Ошибка';
                              }
                            }(),
                            style: Theme.of(context).textTheme.subtitle2,
                          ));
                        }
                      }

                      registerChildWidgets.add(Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: ElevatedButton(
                            child: Text('Регистрация'),
                            onPressed: () {
                              bool valid = true;

                              setState(() {
                                RegExp usernameRegex = RegExp(
                                    r'^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$');

                                String email =
                                    this._emailTextEditingController.text;
                                this._emailErrorText = null;
                                if (email == '') {
                                  this._emailErrorText =
                                      'Введите email для регистрации';
                                  valid = false;
                                } else if (!usernameRegex.hasMatch(email)) {
                                  this._emailErrorText =
                                      'Неверный формат имени пользователя';
                                  valid = false;
                                }

                                String password =
                                    this._passwordTextEditingController.text;
                                String duplicatedPassword = this
                                    ._duplicatePasswordEditingController
                                    .text;
                                this._passwordErrorText = null;
                                if (password == '') {
                                  this._passwordErrorText =
                                      'Необходимо ввести пароль';
                                  valid = false;
                                } else if (password.length < 6) {
                                  this._passwordErrorText =
                                      'Пароль должен содержать минимум 6 символов';
                                  valid = false;
                                }

                                this._duplicatePasswordErrorText = null;

                                if (duplicatedPassword != password) {
                                  this._duplicatePasswordErrorText =
                                      'Пароли не совпадают';
                                  valid = false;
                                }
                              });

                              if (!valid) {
                                return;
                              }

                              _registrationBloc.eventController.sink.add(
                                  RegisterButtonPressedEvent(
                                      login:
                                          this._emailTextEditingController.text,
                                      password: this
                                          ._passwordTextEditingController
                                          .text));
                            },
                          )));

                      return Column(
                        children: registerChildWidgets,
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
