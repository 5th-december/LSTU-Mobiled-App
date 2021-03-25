import 'dart:async';

import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/event/login_event.dart';
import 'package:lk_client/model/response/api_key.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/login_state.dart';

class LoginBloc {
  LoginState _currentLoginState;
  AuthorizationService _authorizationService;
  AuthenticationBloc _authenticationBloc;

  StreamController<LoginState> _stateController =
      StreamController<LoginState>.broadcast();
  Stream<LoginState> get state => _stateController.stream;

  StreamController<LoginEvent> eventController =
      StreamController<LoginEvent>.broadcast();
  Stream<LoginEvent> get _event => eventController.stream;

  void _updateState(LoginState newState) {
    this._currentLoginState = newState;
    this._stateController.add(newState);
  }

  dispose() async {
    this._stateController.close();
    this.eventController.close();
  }

  LoginBloc(AuthorizationService authorizationService,
      AuthenticationBloc authenticationBloc) {
    this._authorizationService = authorizationService;
    this._authenticationBloc = authenticationBloc;
    this._currentLoginState = LoginInitState();

    this._event.listen((LoginEvent event) async {
      if (_currentLoginState is LoginInitState ||
          _currentLoginState is LoginErrorState) {
        if (event is LoginButtonPressedEvent) {
          this._updateState(LoginProcessingState());
          try {
            ApiKey apiKey = await this
                ._authorizationService
                .authenticate(event.userLoginCredentials);
            this
                ._authenticationBloc
                .eventController
                .add(TokenValidateEvent(apiKey));

            this._updateState(LoginInitState());
          } on Exception catch (ble) {
            this._updateState(LoginErrorState(ble));
          }
        }
      }
    });
  }
}
