import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/event/login_event.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/login_state.dart';

class LoginBloc extends AbstractBloc<LoginState, LoginEvent> {
  AuthorizationService _authorizationService;
  AuthenticationBloc _authenticationBloc;

  Stream<LoginState> get state => this.stateContoller.stream;

  Stream<LoginEvent> get _event => this.eventController.stream;

  LoginBloc(AuthorizationService authorizationService,
      AuthenticationBloc authenticationBloc) {
    this._authorizationService = authorizationService;
    this._authenticationBloc = authenticationBloc;
    this.updateState(LoginInitState());

    this._event.listen((LoginEvent event) async {
      if (currentState is LoginInitState || currentState is LoginErrorState) {
        if (event is LoginButtonPressedEvent) {
          this.updateState(LoginProcessingState());
          try {
            ApiKey apiKey = await this
                ._authorizationService
                .authenticate(event.userLoginCredentials);
            this
                ._authenticationBloc
                .eventController
                .add(TokenValidateEvent(apiKey));

            this.updateState(LoginInitState());
          } on Exception catch (ble) {
            this.updateState(LoginErrorState(ble));
          }
        }
      }
    });
  }
}
