import 'dart:async';

import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/event/register_event.dart';
import 'package:lk_client/model/request/login_credentials.dart';
import 'package:lk_client/model/response/api_key.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/register_state.dart';

class RegistrationBloc {
  RegisterState _currentState;
  AuthorizationService _authorizationService;
  AuthenticationBloc _authenticationBloc;

  StreamController<RegisterState> _stateController =
      StreamController<RegisterState>.broadcast();
  Stream<RegisterState> get state => _stateController.stream;

  StreamController<RegisterEvent> eventController =
      StreamController<RegisterEvent>.broadcast();

  Stream<RegisterEvent> get _onRegisterButtonPressed => eventController.stream
      .where((event) => event is RegisterButtonPressedEvent);

  Stream<RegisterEvent> get _onRegistrationCancel => eventController.stream
      .where((event) => event is RegistrationCanceledEvent);

  void _updateState(RegisterState newState) {
    this._currentState = newState;
    this._stateController.sink.add(newState);
  }

  dispose() async {
    await this._stateController.close();
    await this.eventController.close();
  }

  RegistrationBloc(
      AuthorizationService authorizationService,
      AuthenticationBloc authenticationBloc
    ) {
    this._currentState = RegisterInitState();
    this._authorizationService = authorizationService;
    this._authenticationBloc = authenticationBloc;

    this._onRegisterButtonPressed.listen((RegisterEvent event) async {
      RegisterButtonPressedEvent _event = event as RegisterButtonPressedEvent;

      if (_currentState is RegisterInitState ||
          _currentState is RegisterErrorState) {
        this._updateState(RegisterProcessingState());

        try {
          LoginCredentials credentials = LoginCredentials(
              login: _event.login,
              password: _event.password
          );

          ApiKey accessKey =
              await this._authorizationService.register(credentials);

          this
              ._authenticationBloc
              .eventController
              .sink
              .add(TokenValidateEvent(accessKey));

          this._updateState(RegisterInitState());
        } on Exception catch (ex) {
          this._updateState(RegisterErrorState(ex));
        }
      }
    });

    this._onRegistrationCancel.listen((RegisterEvent event) async {
      this._authenticationBloc.eventController.sink.add(AppStartedEvent());
      this._updateState(RegisterInitState());
    });
  }
}
