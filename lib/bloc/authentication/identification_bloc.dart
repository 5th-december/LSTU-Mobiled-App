import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/event/identify_event.dart';
import 'package:lk_client/model/authentication/identify_credentials.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/identify_state.dart';

class IdentificationBloc extends AbstractBloc<IdentifyState, IdentifyEvent> {
  AuthorizationService _authorizationService;
  AuthenticationBloc _authenticationBloc;

  Stream<IdentifyState> get state => this.stateContoller.stream;

  Stream<IdentifyEvent> get _event => this
      .eventController
      .stream
      .where((event) => event is IdentificationButtonPressedEvent);

  IdentificationBloc(AuthorizationService authorizationService,
      AuthenticationBloc authenticationBloc) {
    this._authorizationService = authorizationService;
    this._authenticationBloc = authenticationBloc;
    this.updateState(IdentifyInitState());

    this._event.listen((IdentifyEvent event) async {
      if (currentState is IdentifyInitState ||
          currentState is IdentifyErrorState) {
        IdentificationButtonPressedEvent _event =
            event as IdentificationButtonPressedEvent;

        this.updateState(IdentifyProcessingState());

        IdentifyCredentials credentials = IdentifyCredentials(
            username: _event.name,
            zBookNumber: _event.zBookNumber,
            enterYear: _event.enterYear);

        try {
          ApiKey jwtIdentifier =
              await this._authorizationService.identifyStudent(credentials);
          this
              ._authenticationBloc
              .eventController
              .sink
              .add(IdentifiedEvent(jwtIdentifier));

          this.updateState(IdentifyInitState());
        } on Exception catch (ble) {
          this.updateState(IdentifyErrorState(error: ble));
        }
      }
    });
  }
}
