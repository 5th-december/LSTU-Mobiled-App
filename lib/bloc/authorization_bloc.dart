import 'dart:async';
import '../entity/authorization_data.dart';

class AuthorizationBloc
{
  StreamController<AuthorizationData> makeAuthorizationRequestSink = StreamController<AuthorizationData>();

  Stream<AuthorizationData> get _authorizationData => this.makeAuthorizationRequestSink.stream;

  AuthorizationBloc() {
    this._authorizationData.listen(this._performAuthorizationRequest);
  }

  void _performAuthorizationRequest(AuthorizationData authData) async {

  }
}