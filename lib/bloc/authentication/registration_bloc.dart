import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/event/register_event.dart';
import 'package:lk_client/model/authentication/login_credentials.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/model/util/fcm_key.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/service/api_consumer/util_query_service.dart';
import 'package:lk_client/state/register_state.dart';

class RegistrationBloc extends AbstractBloc<RegisterState, RegisterEvent> {
  final AuthorizationService authorizationService;
  final UtilQueryService utilQueryService;
  final FirebaseMessaging fcmService;
  final AuthenticationBloc authenticationBloc;

  Stream<RegisterState> get state => this.stateContoller.stream;

  Stream<RegisterEvent> get _onRegisterButtonPressed => this
      .eventController
      .stream
      .where((event) => event is RegisterButtonPressedEvent);

  Stream<RegisterEvent> get _onRegistrationCancel => this
      .eventController
      .stream
      .where((event) => event is RegistrationCanceledEvent);

  RegistrationBloc(
      {@required this.authorizationService,
      @required this.authenticationBloc,
      @required this.fcmService,
      @required this.utilQueryService}) {
    this.updateState(RegisterInitState());

    this._onRegisterButtonPressed.listen((RegisterEvent event) async {
      RegisterButtonPressedEvent _event = event as RegisterButtonPressedEvent;

      if (currentState is RegisterInitState ||
          currentState is RegisterErrorState) {
        this.updateState(RegisterProcessingState());

        try {
          LoginCredentials credentials =
              LoginCredentials(login: _event.login, password: _event.password);

          /** 
           * Получение access и refresh токенов
           */
          ApiKey accessKey =
              await this.authorizationService.register(credentials);

          /**
           * Отправка fcm токена приложения
           */
          FcmKey fcmToken = FcmKey(fcmKey: await this.fcmService.getToken());
          bool fcmAdded = await this.utilQueryService.addDeviceFcmKey(fcmToken);
          if (!fcmAdded) {
            throw Exception('Notification server is unavailable');
          }

          /**
           * Сохранение токенов в secure storage
           */
          this
              .authenticationBloc
              .eventController
              .sink
              .add(TokenValidateEvent(accessKey));

          this.updateState(RegisterInitState());
        } on Exception catch (e) {
          this.updateState(RegisterErrorState(e));
        }
      }
    });

    this._onRegistrationCancel.listen((RegisterEvent event) async {
      this.authenticationBloc.eventController.sink.add(AppStartedEvent());
      this.updateState(RegisterInitState());
    });
  }
}
