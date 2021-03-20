import 'dart:async';

import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/state/authentication_state.dart';

class AuthenticationBloc
{
  AuthenticationState _currentAuthenticationState;
  JwtManager _jwtManager;

  StreamController<AuthenticationState> _stateController = StreamController<AuthenticationState>();
  Stream<AuthenticationState> get state => _stateController.stream;

  StreamController<AuthenticationEvent> eventController = StreamController<AuthenticationEvent>();
  Stream<AuthenticationEvent> get _event => eventController.stream;

  void _updateState(AuthenticationState newState) {
    this._currentAuthenticationState = newState;
    this._stateController.add(newState);
  }

  AuthenticationBloc({JwtManager jwtManager}) {
    this._jwtManager = jwtManager;
    this._currentAuthenticationState = AuthenticationUndefinedState();

    this._event.listen((AuthenticationEvent event) async {

      if (event is AppStartedEvent) {
        bool hasJwt = await _jwtManager.hasSavedJwt();

        if(hasJwt) {
          String jwt = await _jwtManager.getSavedJwt();
          
          if (JwtManager.checkJwtValid(jwt)) {
            this._updateState(AuthenticationSuccessState());
          } 
          else {
            try {
              this._updateState(AuthenticationProcessingState());
              //update token
              await this._jwtManager.setSavedJwt(jwt);
              this._updateState(AuthenticationSuccessState());
            } on Exception {
              this._updateState(AuthenticationUnauthorizedState());
            }
          }
        } 
        else {
          this._updateState(AuthenticationUnauthorizedState());
        }
      }

      if (event is LoggedInEvent) {
        this._updateState(AuthenticationProcessingState());
        await this._jwtManager.setSavedJwt(event.apiToken.token);
        this._updateState(AuthenticationSuccessState());
      }

      if (event is LoggedOutEvent) {
        this._updateState(AuthenticationProcessingState());
        await this._jwtManager.removeSavedJwt();
        this._updateState(AuthenticationUnauthorizedState());
      }
    });
  }
}