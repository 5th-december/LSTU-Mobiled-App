import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/state/authentication_state.dart';

class AuthenticationExtractor {
  final AuthenticationBloc appAuthenticator;

  AuthenticationExtractor(this.appAuthenticator);

  ApiKey getAuthenticationData() {
    AuthenticationState currentAuthenticationState =
        appAuthenticator.currentState;

    if (currentAuthenticationState is AuthenticationValidState) {
      return currentAuthenticationState.validToken;
    }

    // необходимо добавить обработку случая, когда состояние отличается от
    // залогинного и проверять валидность токена
    throw Exception('Not implemented');
  }
}
