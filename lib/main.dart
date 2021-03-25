import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/model/error/api_system_error_handler.dart';
import 'package:lk_client/model/error/duplicate_error_handler.dart';
import 'package:lk_client/model/error/error_judge.dart';
import 'package:lk_client/model/error/not_found_error_handler.dart';
import 'package:lk_client/model/error/stub_error_handler.dart';
import 'package:lk_client/model/error/validation_error_handler.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/store/bloc_provider.dart';
import 'package:lk_client/store/service_provider.dart';
import 'app.dart';
import 'store/app_state_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // API exceptions handlers chain of responsibility
  StubErrorHandler stubErrorHandler = StubErrorHandler();
  ValidationErrorHandler validationErrorHandler = ValidationErrorHandler(stubErrorHandler);
  DuplicateErrorHandler duplicateErrorHandler = DuplicateErrorHandler(validationErrorHandler);
  NotFoundErrorHandler notFoundErrorHandler = NotFoundErrorHandler(duplicateErrorHandler);
  ApiSystemErrorHandler apiSystemErrorHandler = ApiSystemErrorHandler(notFoundErrorHandler);
  ErrorJudge apiErrorHandlersChain = new ErrorJudge(apiSystemErrorHandler);

  // Application level services

  // Define application environment constant here
  final appEnv = 'dev';
  AppConfig appConfig = await AppConfig.configure(env: appEnv);
  JwtManager appJwt = JwtManager.instance;
  AuthorizationService appAuthorizationService = AuthorizationService(appConfig, apiErrorHandlersChain, appJwt);
  ServiceProvider applicationServiceProvider = ServiceProvider(
    appConfig: appConfig, 
    jwtManager: appJwt, 
    authorizationService: appAuthorizationService
  );

  AuthenticationBloc appAuthenticationBloc =
      AuthenticationBloc(applicationServiceProvider.jwtManager, applicationServiceProvider.authorizationService);
  // send start event to app authentication bloc in order to 
  // start authorization immediately after app running
  appAuthenticationBloc.eventController.sink.add(AppStartedEvent());

  BlocProvider blocProvider = BlocProvider(
    authenticationBloc: appAuthenticationBloc
  );
  
  runApp(
    AppStateContainer(
      child: LkApp(appAuthorizationService),
      blocProvider: blocProvider,
      serviceProvider: applicationServiceProvider
    )
  );
}
