import 'dart:async';
import 'dart:convert';

import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/state/authentication_state.dart';

class AuthenticationExtractor {
  final AuthorizationService _authorizationService;
  final AuthenticationBloc _bloc;

  AuthenticationExtractor(this._authorizationService, this._bloc);

  bool _checkJwtValid(String jwtToken) {
    List<String> splittedJwt = jwtToken.split('.');
    if (splittedJwt.length != 3) {
      throw new FormatException();
    }
    String payload = splittedJwt[1];
    var encodedJwt =
        json.decode(ascii.decode(base64.decode(base64.normalize(payload))));
    var exp = (encodedJwt['exp'] ?? 0) * 1000;
    return DateTime.fromMillisecondsSinceEpoch(exp).isAfter(DateTime.now());
  }

  Future<ApiKey> applyKey([bool forced = false]) async {
    if (this._bloc.currentState is Tokenized) {
      final key = (this._bloc.currentState as Tokenized).token;

      try {
        final isValid = !forced && this._checkJwtValid(key.token);

        if (!isValid) {
          if (this._bloc.currentState is AuthenticationIdentifiedState) {
            this._bloc.eventController.sink.add(TokenInvalidateEvent());
          } else {
            final updatedKey = await this._authorizationService.updateJwt(key);

            if (this._bloc.currentState is AuthenticationValidState) {
              this._bloc.eventController.sink.add(TokenUpdateEvent(updatedKey));
            } else {
              this
                  ._bloc
                  .eventController
                  .sink
                  .add(TokenValidateEvent(updatedKey));
            }
          }
        } else {
          if (!(this._bloc.currentState is AuthenticationValidState ||
              this._bloc.currentState is AuthenticationIdentifiedState)) {
            this._bloc.eventController.sink.add(TokenValidateEvent(key));
          }
        }
      } on Exception {
        this._bloc.eventController.sink.add(TokenInvalidateEvent());
      }
    }

    if (this._bloc.currentState is AuthenticationUndefinedState) {
      this._bloc.eventController.sink.add(TokenInvalidateEvent());
    }

    Completer<ApiKey> completer = Completer<ApiKey>();

    Future.delayed(Duration.zero, () async {
      await for (AuthenticationState state in this._bloc.state) {
        if (state is AuthenticationValidState ||
            state is AuthenticationIdentifiedState) {
          completer.complete((this._bloc.currentState as Tokenized).token);
          break;
        }
      }
    });

    return completer.future;
  }

  Future<String> get getAuthenticationData async {
    ApiKey actualKey = await this.applyKey(false);
    return actualKey.token;
  }
}
