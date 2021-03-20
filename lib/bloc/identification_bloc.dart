import 'dart:async';

import 'package:lk_client/bloc/login_bloc.dart';
import 'package:lk_client/bloc/registration_bloc.dart';
import 'package:lk_client/event/identify_event.dart';
import 'package:lk_client/event/register_event.dart';
import 'package:lk_client/exception/business_logic_exception.dart';
import 'package:lk_client/model/request/user_identify_credentials.dart';
import 'package:lk_client/model/response/business_logic_error.dart';
import 'package:lk_client/model/response/student_identifier.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/state/identify_state.dart';

class IdentificationBloc
{
  IdentifyState _currentState;
  AuthorizationService _authorizationService;
  RegistrationBloc _registrationBloc;

  StreamController<IdentifyState> _stateController = StreamController<IdentifyState>();
  Stream<IdentifyState> get state => _stateController.stream;

  StreamController<IdentifyEvent> eventController = StreamController<IdentifyEvent>.broadcast();
  Stream<IdentifyEvent> get _event => eventController.stream.where(
    (event) => event is IdentificationButtonPressedEvent
  );

  void _updateState(IdentifyState newState) {
    this._currentState = newState;
    this._stateController.add(newState);
  }

  IdentificationBloc(AuthorizationService authorizationService, RegistrationBloc registrationBloc) {
    this._authorizationService = authorizationService;
    this._registrationBloc = registrationBloc;
    this._currentState = IdentifyInitState();

    this._event.listen((IdentifyEvent event) async {
      if (_currentState is IdentifyInitState || _currentState is IdentifyErrorState) {
        IdentificationButtonPressedEvent _event = event as IdentificationButtonPressedEvent;
        this._updateState(IdentifyProcessingState());

        UserIdentifyCredentials credentials = UserIdentifyCredentials(
          name: _event.name,
          zNumber: _event.zBookNumber,
          enterYear: _event.enterYear
        );

        try {
          StudentIdentifier studentIdentifier = await this._authorizationService.identifyStudent(credentials);
          this._registrationBloc.eventController.sink.add(UserIdentifiedEvent(studentIdentifier: studentIdentifier));
          this._updateState(IdentifyInitState());
        } on BusinessLogicException catch(ble) {
          this._updateState(IdentifyErrorState(error: ble.error));
        } on Exception {
          this._updateState(IdentifyErrorState(
            error: BusinessLogicError(
              userMessage: 'Произошла неожиданная ошибка'
            )
          ));
        }
      }
    });
  }
}