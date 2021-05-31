import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication/registration_bloc.dart';
import 'package:lk_client/event/register_event.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/state/register_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';

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

  RegistrationBloc _registrationBloc;

  String _emailErrorText;
  String _passwordErrorText;

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
