import 'dart:async';

import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/model/response/jwt_token.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/state/authentication_state.dart';

class AuthenticationBloc
{
  AuthenticationState _currentAuthenticationState;
  JwtManager _jwtManager;

  StreamController<AuthenticationState> _stateController = StreamController<AuthenticationState>.broadcast();
  Stream<AuthenticationState> get state => _stateController.stream;

  StreamController<AuthenticationEvent> eventController = StreamController<AuthenticationEvent>.broadcast();
  Stream<AuthenticationEvent> get _appStartedEventStream => eventController.stream.where((event) => event is AppStartedEvent);
  Stream<AuthenticationEvent> get _loggedInEventStream => eventController.stream.where((event) => event is LoggedInEvent);
  Stream<AuthenticationEvent> get _loggedOutEventStream => eventController.stream.where((event) => event is LoggedOutEvent);
  Stream<AuthenticationEvent> get _identifiedEventStream => eventController.stream.where((event) => event is IdentifiedEvent);

  void _updateState(AuthenticationState newState) {
    this._currentAuthenticationState = newState;
    this._stateController.add(newState);
  }

  dispose() async {
    await this._stateController.close();
    await this.eventController.close();
  }

  AuthenticationBloc({JwtManager jwtManager}) {
    this._jwtManager = jwtManager;
    this._currentAuthenticationState = AuthenticationUndefinedState();

    this._appStartedEventStream.listen((AuthenticationEvent event) async {
      this._updateState(AuthenticationProcessingState());

      bool hasJwt = await _jwtManager.hasSavedJwt();
      //
      hasJwt = false;
      if(hasJwt) {
        String jwt = await _jwtManager.getSavedJwt();
          
        if (JwtManager.checkJwtValid(jwt)) {
          this._updateState(AuthenticationSuccessState(JwtToken(token: jwt)));
        } 
        else {
          try {
            this._updateState(AuthenticationProcessingState());
            //update token
            await this._jwtManager.setSavedJwt(jwt);
            this._updateState(AuthenticationSuccessState(JwtToken(token: jwt)));
          } on Exception {
            this._updateState(AuthenticationUnauthorizedState());
          }
        }
      } 
      else {
        this._updateState(AuthenticationUnauthorizedState());
      }
    });

    this._identifiedEventStream.listen((AuthenticationEvent event) async {
      IdentifiedEvent _event = event as IdentifiedEvent;
      this._updateState(AuthenticationIdentifiedState(_event.identifier));
    });

    this._loggedInEventStream.listen((AuthenticationEvent event) async {
      LoggedInEvent _event = event as LoggedInEvent;
      this._updateState(AuthenticationProcessingState());

      await this._jwtManager.setSavedJwt(_event.apiToken.token);
      JwtToken token = JwtToken(token: _event.apiToken.token);

      this._updateState(AuthenticationSuccessState(token));
    });

    this._loggedOutEventStream.listen((AuthenticationEvent event) async {
      this._updateState(AuthenticationProcessingState());
      await this._jwtManager.removeSavedJwt();
      this._updateState(AuthenticationUnauthorizedState());
    });
  }
}