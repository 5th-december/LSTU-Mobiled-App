import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/model/response/api_key.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/state/authentication_state.dart';

class AuthenticationBloc
    extends AbstractBloc<AuthenticationState, AuthenticationEvent> {
  JwtManager _jwtManager;
  AuthorizationService _authorizationService;

  Stream<AuthenticationState> get state => this.stateContoller.stream;

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

  AuthenticationBloc(
      JwtManager jwtManager, AuthorizationService authorizationService) {
    this._jwtManager = jwtManager;
    this._authorizationService = authorizationService;
    this.updateState(AuthenticationUndefinedState());

    this._appStartedEventStream.listen((AuthenticationEvent event) async {
      this.updateState(AuthenticationProcessingState());

      bool hasJwt = await _jwtManager.hasSavedKeyPair();

      hasJwt = false;
      if (hasJwt) {
        String jwt = await _jwtManager.getSavedJwt();
        if (JwtManager.checkJwtValid(jwt)) {
          ApiKey existingKey = ApiKey(token: jwt);
          this.updateState(AuthenticationValidState(existingKey));
        } else {
          String refresh = await _jwtManager.getSavedRefresh();
          try {
            ApiKey accessKey = ApiKey(token: jwt, refreshToken: refresh);
            this.updateState(AuthenticationProcessingState());
            ApiKey updatedKey =
                await this._authorizationService.updateJwt(accessKey);
            await this._jwtManager.setSavedJwt(updatedKey.token);
            await this._jwtManager.setSavedRefresh(updatedKey.refreshToken);
            this.updateState(AuthenticationValidState(updatedKey));
          } on Exception {
            this.updateState(AuthenticationUnauthorizedState());
          }
        }
      } else {
        this.updateState(AuthenticationUnauthorizedState());
      }
    });

    this._identifiedEventStream.listen((AuthenticationEvent event) async {
      IdentifiedEvent _event = event as IdentifiedEvent;
      await this._jwtManager.setSavedJwt(_event.identificationKey.token);
      this.updateState(AuthenticationIdentifiedState(_event.identificationKey));
    });

    this._validatedEventStream.listen((AuthenticationEvent event) async {
      TokenValidateEvent _event = event as TokenValidateEvent;
      this.updateState(AuthenticationProcessingState());
      await this._jwtManager.setSavedJwt(_event.validToken.token);
      await this._jwtManager.setSavedRefresh(_event.validToken.refreshToken);
      this.updateState(AuthenticationValidState(_event.validToken));
    });

    this._invalidatedEventStream.listen((AuthenticationEvent event) async {
      TokenInvalidateEvent _event = event as TokenInvalidateEvent;
      this.updateState(AuthenticationInvalidState(_event.invalidToken));
      try {
        ApiKey updatedKey =
            await this._authorizationService.updateJwt(_event.invalidToken);
        this._jwtManager.setSavedJwt(updatedKey.token);
        this._jwtManager.setSavedRefresh(updatedKey.refreshToken);
        this.updateState(AuthenticationValidState(updatedKey));
      } on Exception {
        this.updateState(AuthenticationUnauthorizedState());
      }
    });

    this._loggedOutEventStream.listen((AuthenticationEvent event) async {
      this.updateState(AuthenticationProcessingState());
      await this._jwtManager.removeSavedJwt();
      this.updateState(AuthenticationUnauthorizedState());
    });
  }
}
