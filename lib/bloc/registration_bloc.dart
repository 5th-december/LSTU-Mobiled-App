
import 'dart:async';

import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/event/register_event.dart';
import 'package:lk_client/exception/business_logic_exception.dart';
import 'package:lk_client/model/request/user_register_credentials.dart';
import 'package:lk_client/model/response/business_logic_error.dart';
import 'package:lk_client/model/response/jwt_token.dart';
import 'package:lk_client/model/response/student_identifier.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/register_state.dart';

class RegistrationBloc
{
  RegisterState _currentState;
  AuthorizationService _authorizationService;
  AuthenticationBloc _authenticationBloc;

  StreamController<RegisterState> _stateController = StreamController<RegisterState>();
  Stream<RegisterState> get state => _stateController.stream;

  StreamController<RegisterEvent> eventController = StreamController<RegisterEvent>.broadcast();
  Stream<RegisterEvent> get _onUserIdentifiedEvent => eventController.stream.where(
    (event) => event is UserIdentifiedEvent
  );

  Stream<RegisterEvent> get _onRegisterButtonPressed => eventController.stream.where(
    (event) => event is RegisterButtonPressedEvent
  );

  Stream<RegisterEvent> get _onRegistrationCancel => eventController.stream.where(
    (event) => event is RegistrationCanceledEvent
  );

  void _updateState(RegisterState newState) {
    this._currentState = newState;
    this._stateController.sink.add(newState);
  }

  RegistrationBloc(AuthorizationService authorizationService, AuthenticationBloc authenticationBloc) {
    this._currentState = RegisterInitState();
    this._authorizationService = authorizationService;
    this._authenticationBloc = authenticationBloc;

    this._onUserIdentifiedEvent.listen((RegisterEvent event) async {
      UserIdentifiedEvent _event = event as UserIdentifiedEvent;

      if(_currentState is RegisterInitState) {
        this._updateState(RegisterIdentifiedState(identifier: _event.studentIdentifier));
      }
    });

    this._onRegisterButtonPressed.listen((RegisterEvent event) async {
      RegisterButtonPressedEvent _event = event as RegisterButtonPressedEvent;

      if (_currentState is RegisterIdentifiedState) {
        this._updateState(RegisterProcessingState());

        try {
          UserRegisterCredentials credentials = UserRegisterCredentials(
            login: _event.login,
            password: _event.password,
            temporaryLoggingId: (_currentState as RegisterIdentifiedState).identifier.temporaryLoggingId
          );
          JwtToken userToken = await this._authorizationService.register(credentials);
          this._authenticationBloc.eventController.sink.add(LoggedInEvent(apiToken: userToken));
          this._updateState(RegisterInitState());
        } on BusinessLogicException catch(ble) {
          this._updateState(RegisterErrorState(error: ble.error));
        } on Exception {
          this._updateState(RegisterErrorState(error: new BusinessLogicError(
            code: 'REGISTER_ERROR',
            systemMessage: 'REGISTER_ERROR',
            userMessage: 'Ошибка регистрации',
            errorProperties: {}
          )));
        }
      }
    });

    this._onRegistrationCancel.listen((RegisterEvent event) async {
      RegistrationCanceledEvent _event = event as RegistrationCanceledEvent;
      this._updateState(RegisterInitState());
    });
  }
}