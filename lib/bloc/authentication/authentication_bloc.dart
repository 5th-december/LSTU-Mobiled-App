import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/state/authentication_state.dart';

class AuthenticationBloc
    extends AbstractBloc<AuthenticationState, AuthenticationEvent> {
  Stream<AuthenticationState> get state => this.stateContoller.stream;

  Stream<AuthenticationEvent> get _appStartedEventStream =>
      eventController.stream.where((event) => event is AppStartedEvent);
  Stream<AuthenticationEvent> get _invalidatedEventStream =>
      eventController.stream.where((event) => event is TokenInvalidateEvent);
  Stream<AuthenticationEvent> get _forceUpdatedEventStream =>
      eventController.stream.where((event) => event is TokenForcedUpdateEvent);
  Stream<AuthenticationEvent> get _validatedEventStream =>
      eventController.stream.where((event) => event is TokenValidateEvent);
  Stream<AuthenticationEvent> get _tokenUpdatedEventStream =>
      eventController.stream.where((event) => event is TokenUpdateEvent);
  Stream<AuthenticationEvent> get _loggedOutEventStream =>
      eventController.stream.where((event) => event is LoggedOutEvent);
  Stream<AuthenticationEvent> get _identifiedEventStream =>
      eventController.stream.where((event) => event is IdentifiedEvent);

  AuthenticationExtractor _authenticationExtractor;

  AuthenticationExtractor get authenticationExtractor =>
      this._authenticationExtractor;

  AuthenticationBloc(
      {@required JwtManager jwtManager,
      @required AuthorizationService authorizationService}) {
    this.updateState(AuthenticationUndefinedState());

    this._authenticationExtractor =
        AuthenticationExtractor(authorizationService, this);

    this._appStartedEventStream.listen((AuthenticationEvent event) async {
      this.updateState(AuthenticationProcessingState());

      bool hasJwt = await jwtManager.hasSavedKeyPair();

      if (hasJwt) {
        String jwt = await jwtManager.getSavedJwt();
        String refresh = await jwtManager.getSavedRefresh();
        this.updateState(AuthenticationInvalidState(
            ApiKey(token: jwt, refreshToken: refresh)));

        await authenticationExtractor.applyKey();
      } else {
        this.updateState(AuthenticationUnauthorizedState());
      }
    });

    this._identifiedEventStream.listen((AuthenticationEvent event) async {
      IdentifiedEvent _event = event as IdentifiedEvent;

      await jwtManager.setSavedJwt(_event.identificationKey.token);

      this.updateState(AuthenticationIdentifiedState(_event.identificationKey));
    });

    this._validatedEventStream.listen((AuthenticationEvent event) async {
      TokenValidateEvent _event = event as TokenValidateEvent;

      this.updateState(AuthenticationProcessingState());

      await jwtManager.setSavedJwt(_event.validToken.token);
      await jwtManager.setSavedRefresh(_event.validToken.refreshToken);

      this.updateState(AuthenticationValidState(_event.validToken));
    });

    this._tokenUpdatedEventStream.listen((AuthenticationEvent event) async {
      TokenUpdateEvent _event = event as TokenUpdateEvent;

      if (this.currentState is AuthenticationValidState) {
        await jwtManager.setSavedJwt(_event.updatedToken.token);
        await jwtManager.setSavedRefresh(_event.updatedToken.refreshToken);
        (this.currentState as AuthenticationValidState).token = ApiKey(
            token: _event.updatedToken.token,
            refreshToken: _event.updatedToken.refreshToken);
      }
    });

    this._invalidatedEventStream.listen((AuthenticationEvent event) async {
      this.updateState(AuthenticationProcessingState());

      await jwtManager.removeSavedJwt();
      await jwtManager.removeSavedRefresh();

      this.updateState(AuthenticationUnauthorizedState());
    });

    this._forceUpdatedEventStream.listen((AuthenticationEvent event) async {
      this.updateState(AuthenticationProcessingState());

      await authenticationExtractor.applyKey(true);
    });

    this._loggedOutEventStream.listen((AuthenticationEvent event) async {
      this.updateState(AuthenticationProcessingState());

      await jwtManager.removeSavedJwt();
      await jwtManager.removeSavedRefresh();

      this.updateState(AuthenticationUnauthorizedState());
    });
  }
}
