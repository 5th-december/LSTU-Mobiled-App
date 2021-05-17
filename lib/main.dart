import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication_bloc.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/error_handler/access_denied_error_handler.dart';
import 'package:lk_client/error_handler/data_access_error_handler.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/error_handler/api_system_error_handler.dart';
import 'package:lk_client/error_handler/duplicate_error_handler.dart';
import 'package:lk_client/error_handler/error_judge.dart';
import 'package:lk_client/error_handler/not_found_error_handler.dart';
import 'package:lk_client/error_handler/stub_error_handler.dart';
import 'package:lk_client/error_handler/validation_error_handler.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/file_transfer_manager.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/store/global/bloc_provider.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'app.dart';
import 'store/global/app_state_container.dart';

Future<void> main() async {
  // Debug
  //debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();

  // API exceptions handlers chain of responsibility
  StubErrorHandler stubErrorHandler = StubErrorHandler();
  ValidationErrorHandler validationErrorHandler =
      ValidationErrorHandler(stubErrorHandler);
  DuplicateErrorHandler duplicateErrorHandler =
      DuplicateErrorHandler(validationErrorHandler);
  NotFoundErrorHandler notFoundErrorHandler =
      NotFoundErrorHandler(duplicateErrorHandler);
  ApiSystemErrorHandler apiSystemErrorHandler =
      ApiSystemErrorHandler(notFoundErrorHandler);
  AccessDeniedErrorHandler accessDeniedErrorHandler =
      AccessDeniedErrorHandler(apiSystemErrorHandler);
  DataAccessErrorHandler dataAccessErrorHandler =
      DataAccessErrorHandler(accessDeniedErrorHandler);
  ErrorJudge apiErrorHandlersChain = new ErrorJudge(dataAccessErrorHandler);

  // Application level services

  // Define application environment constant here
  final appEnv = 'dev';
  AppConfig appConfig = await AppConfig.configure(env: appEnv);
  JwtManager appJwt = JwtManager.instance;
  ApiEndpointConsumer appApiEndpointConsumer = ApiEndpointConsumer(appConfig);

  AuthorizationService appAuthorizationService = AuthorizationService(
      appApiEndpointConsumer, apiErrorHandlersChain, appJwt);

  AuthenticationBloc appAuthenticationBloc =
      AuthenticationBloc(appJwt, appAuthorizationService);

  AuthenticationExtractor appAuthenticationExtractor =
      AuthenticationExtractor(appAuthenticationBloc);

  PersonQueryService appPersonQueryService = PersonQueryService(
      appApiEndpointConsumer,
      appAuthenticationExtractor,
      apiErrorHandlersChain);
  EducationQueryService appEducationQueryService = EducationQueryService(
      appApiEndpointConsumer,
      appAuthenticationExtractor,
      apiErrorHandlersChain);

  DisciplineQueryService appDisciplineQueryService = DisciplineQueryService(
      appApiEndpointConsumer,
      apiErrorHandlersChain,
      appAuthenticationExtractor);

  FileLocalManager appFileLocalManager = FileLocalManager();

  FileTransferManager appFileTransferManager = FileTransferManager(
      appConfig, appApiEndpointConsumer, appFileLocalManager);

  FileTransferService appFileTransferService =
      FileTransferService(appFileTransferManager, appAuthenticationExtractor);

  MessengerQueryService appMessengerQueryService = MessengerQueryService(
    apiEndpointConsumer: appApiEndpointConsumer,
    apiErrorHandler: apiErrorHandlersChain,
    authenticationExtractor: appAuthenticationExtractor
  );

  ServiceProvider applicationServiceProvider = ServiceProvider(
      disciplineQueryService: appDisciplineQueryService,
      appConfig: appConfig,
      fileTransferService: appFileTransferService,
      fileLocalManager: appFileLocalManager,
      fileTransferManager: appFileTransferManager,
      jwtManager: appJwt,
      authorizationService: appAuthorizationService,
      messengerQueryService: appMessengerQueryService,
      personQueryService: appPersonQueryService,
      educationQueryService: appEducationQueryService);

  // send start event to app authentication bloc in order to
  // start authorization immediately after app running
  appAuthenticationBloc.eventController.sink.add(AppStartedEvent());

  NavigationBloc appNavigationBloc = NavigationBloc();

  BlocProvider blocProvider = BlocProvider(
      authenticationBloc: appAuthenticationBloc,
      navigationBloc: appNavigationBloc);

  runApp(AppStateContainer(
      child: LkApp(appAuthorizationService),
      blocProvider: blocProvider,
      serviceProvider: applicationServiceProvider));
}
