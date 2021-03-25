import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/bloc/identification_bloc.dart';
import 'package:lk_client/bloc/login_bloc.dart';
import 'package:lk_client/bloc/registration_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/model/error/duplicate_error_handler.dart';
import 'package:lk_client/model/error/error_judge.dart';
import 'package:lk_client/model/error/validation_error_handler.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/store/bloc_provider.dart';
import 'app.dart';
import 'store/app_state_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ValidationErrorHandler validationErrorHandler =
      new ValidationErrorHandler(null);
  DuplicateErrorHandler duplicateErrorHandler =
      new DuplicateErrorHandler(validationErrorHandler);
  ErrorJudge errorJudge = new ErrorJudge(duplicateErrorHandler);
  var value = errorJudge.apply(<String, dynamic>{
    'code': 400,
    'error': 'ERR_VALIDATION',
    'generic_message': 'test',
    'error_messages': <String, String>{'a': 'b'}
  });
  var x = value is ValidationException;

  final appEnv = 'dev';
  AppConfig config = await AppConfig.configure(env: appEnv);
  AuthorizationService appAuthorizationService =
      AuthorizationService(config, errorJudge);

  AuthenticationBloc appAuthenticationBloc =
      AuthenticationBloc(jwtManager: JwtManager.instance);
  appAuthenticationBloc.eventController.sink.add(AppStartedEvent());

  BlocProvider blocProvider = BlocProvider(
      authenticationBloc: appAuthenticationBloc,
      loginBloc: null,
      registrationBloc: null,
      identificationBloc: null);

  runApp(AppStateContainer(
    child: LkApp(appAuthorizationService),
    blocProvider: blocProvider,
  ));
}
