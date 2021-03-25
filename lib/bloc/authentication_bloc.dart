import 'dart:async';

import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/model/response/api_key.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/state/authentication_state.dart';

class AuthenticationBloc {
  AuthenticationState _currentAuthenticationState;
  JwtManager _jwtManager;
  AuthorizationService _authorizationService;

  StreamController<AuthenticationState> _stateController =
      StreamController<AuthenticationState>.broadcast();
  Stream<AuthenticationState> get state => _stateController.stream;

  StreamController<AuthenticationEvent> eventController =
      StreamController<AuthenticationEvent>.broadcast();
  Stream<AuthenticationEvent> get _appStartedEventStream =>
      eventController.stream.where((event) => event is AppStartedEvent);
  Stream<AuthenticationEvent> get _invalidatedEventStream =>
      eventController.stream.where((event) => event is TokenInvalidateEvent);
  Stream<AuthenticationEvent> get _validatedEventStream =>
      eventController.stream.where((event) => event is TokenValidateEvent);
  Stream<AuthenticationEvent> get _loggedOutEventStream =>
      eventController.stream.where((event) => event is LoggedOutEvent);
  Stream<AuthenticationEvent> get _identifiedEventStream =>
      eventController.stream.where((event) => event is IdentifiedEvent);

  void _updateState(AuthenticationState newState) {
    this._currentAuthenticationState = newState;
    this._stateController.add(newState);
  }

  dispose() async {
    await this._stateController.close();
    await this.eventController.close();
  }

  AuthenticationBloc(JwtManager jwtManager, AuthorizationService authorizationService) {
    this._jwtManager = jwtManager;
    this._authorizationService = authorizationService;
    this._currentAuthenticationState = AuthenticationUndefinedState();

    this._appStartedEventStream.listen((AuthenticationEvent event) async {
      this._updateState(AuthenticationProcessingState());

      bool hasJwt = await _jwtManager.hasSavedKeyPair();
      
      hasJwt = false;
      if (hasJwt) {
        String jwt = await _jwtManager.getSavedJwt();
        if (JwtManager.checkJwtValid(jwt)) {
          ApiKey existingKey = ApiKey(token: jwt);
          this._updateState(AuthenticationValidState(existingKey));
        } else {
          String refresh = await _jwtManager.getSavedRefresh();
          try {
            ApiKey accessKey = ApiKey(token: jwt, refreshToken: refresh);
            this._updateState(AuthenticationProcessingState());
            ApiKey updatedKey = await this._authorizationService.updateJwt(accessKey);
            await this._jwtManager.setSavedJwt(updatedKey.token);
            await this._jwtManager.setSavedRefresh(updatedKey.refreshToken);
            this._updateState(AuthenticationValidState(updatedKey));
          } on Exception {
            this._updateState(AuthenticationUnauthorizedState());
          }
        }
      } else {
        this._updateState(AuthenticationUnauthorizedState());
      }
    });

    this._identifiedEventStream.listen((AuthenticationEvent event) async {
      IdentifiedEvent _event = event as IdentifiedEvent;
      await this._jwtManager.setSavedJwt(_event.identificationKey.token);
      this._updateState(AuthenticationIdentifiedState(_event.identificationKey));
    });

    this._validatedEventStream.listen((AuthenticationEvent event) async {
      TokenValidateEvent _event = event as TokenValidateEvent;
      this._updateState(AuthenticationProcessingState());
      await this._jwtManager.setSavedJwt(_event.validToken.token);
      await this._jwtManager.setSavedRefresh(_event.validToken.refreshToken);
      this._updateState(AuthenticationValidState(_event.validToken));
    });

    this._invalidatedEventStream.listen((AuthenticationEvent event) async {
      TokenInvalidateEvent _event = event as TokenInvalidateEvent;
      this._updateState(AuthenticationInvalidState(_event.invalidToken));
      try {
        ApiKey updatedKey = await this._authorizationService.updateJwt(_event.invalidToken);
        this._jwtManager.setSavedJwt(updatedKey.token);
        this._jwtManager.setSavedRefresh(updatedKey.refreshToken);
        this._updateState(AuthenticationValidState(updatedKey));
      } on Exception {
        this._updateState(AuthenticationUnauthorizedState());
      }
    });

    this._loggedOutEventStream.listen((AuthenticationEvent event) async {
      this._updateState(AuthenticationProcessingState());
      await this._jwtManager.removeSavedJwt();
      this._updateState(AuthenticationUnauthorizedState());
    });
  }
}
