import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/event/login_event.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/model/util/fcm_key.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/service/api_consumer/util_query_service.dart';
import 'package:lk_client/state/login_state.dart';

class LoginBloc extends AbstractBloc<LoginState, LoginEvent> {
  final AuthorizationService authorizationService;
  final AuthenticationBloc authenticationBloc;
  final UtilQueryService utilQueryService;
  final FirebaseMessaging fcmService;

  Stream<LoginState> get state => this.stateContoller.stream;

  Stream<LoginEvent> get _event => this.eventController.stream;

  LoginBloc(
      {@required this.authorizationService,
      @required this.authenticationBloc,
      @required this.utilQueryService,
      @required this.fcmService}) {
    this.updateState(LoginInitState());

    this._event.listen((LoginEvent event) async {
      if (currentState is LoginInitState || currentState is LoginErrorState) {
        if (event is LoginButtonPressedEvent) {
          this.updateState(LoginProcessingState());

          /**
           * Получение access и refresh токенов
           */
          try {
            ApiKey apiKey = await this
                .authorizationService
                .authenticate(event.userLoginCredentials);

            this
                .authenticationBloc
                .eventController
                .add(TokenValidateEvent(apiKey));

            /**
           * Отправка fcm токена приложения
           */
            FcmKey fcmToken = FcmKey(fcmKey: await this.fcmService.getToken());
            bool fcmAdded =
                await this.utilQueryService.addDeviceFcmKey(fcmToken);
            if (!fcmAdded) {
              throw Exception('Notification server is unavailable');
            }

            this.updateState(LoginInitState());
          } on Exception catch (e) {
            this.updateState(LoginErrorState(e));
          }
        }
      }
    });
  }
}
