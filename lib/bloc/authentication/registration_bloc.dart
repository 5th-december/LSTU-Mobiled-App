import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/event/register_event.dart';
import 'package:lk_client/model/request/login_credentials.dart';
import 'package:lk_client/model/response/api_key.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/register_state.dart';

class RegistrationBloc extends AbstractBloc<RegisterState, RegisterEvent> {
  AuthorizationService _authorizationService;
  AuthenticationBloc _authenticationBloc;

  Stream<RegisterState> get state => this.stateContoller.stream;

  Stream<RegisterEvent> get _onRegisterButtonPressed => this
      .eventController
      .stream
      .where((event) => event is RegisterButtonPressedEvent);

  Stream<RegisterEvent> get _onRegistrationCancel => this
      .eventController
      .stream
      .where((event) => event is RegistrationCanceledEvent);

  RegistrationBloc(AuthorizationService authorizationService,
      AuthenticationBloc authenticationBloc) {
    this.updateState(RegisterInitState());
    this._authorizationService = authorizationService;
    this._authenticationBloc = authenticationBloc;

    this._onRegisterButtonPressed.listen((RegisterEvent event) async {
      RegisterButtonPressedEvent _event = event as RegisterButtonPressedEvent;

      if (currentState is RegisterInitState ||
          currentState is RegisterErrorState) {
        this.updateState(RegisterProcessingState());

        try {
          LoginCredentials credentials =
              LoginCredentials(login: _event.login, password: _event.password);

          ApiKey accessKey =
              await this._authorizationService.register(credentials);

          this
              ._authenticationBloc
              .eventController
              .sink
              .add(TokenValidateEvent(accessKey));

          this.updateState(RegisterInitState());
        } on Exception catch (ex) {
          this.updateState(RegisterErrorState(ex));
        }
      }
    });

    this._onRegistrationCancel.listen((RegisterEvent event) async {
      this._authenticationBloc.eventController.sink.add(AppStartedEvent());
      this.updateState(RegisterInitState());
    });
  }
}
