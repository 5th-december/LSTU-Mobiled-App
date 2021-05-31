import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lk_client/bloc/authentication/authentication_bloc.dart';
import 'package:lk_client/bloc/navigation_bloc.dart';
import 'package:lk_client/bloc/notification_prefs_bloc.dart';
import 'package:lk_client/error_handler/access_denied_error_handler.dart';
import 'package:lk_client/error_handler/data_access_error_handler.dart';
import 'package:lk_client/event/authentication_event.dart';
import 'package:lk_client/error_handler/api_system_error_handler.dart';
import 'package:lk_client/error_handler/duplicate_error_handler.dart';
import 'package:lk_client/error_handler/error_judge.dart';
import 'package:lk_client/error_handler/not_found_error_handler.dart';
import 'package:lk_client/error_handler/stub_error_handler.dart';
import 'package:lk_client/error_handler/validation_error_handler.dart';
import 'package:lk_client/event/notification_prefs_event.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/api_consumer/achievement_query_service.dart';
import 'package:lk_client/service/api_consumer/discipline_query_service.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/service/api_consumer/util_query_service.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/api_consumer/authorization_service.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/service/file_transfer_manager.dart';
import 'package:lk_client/service/hive_service.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/service/jwt_manager.dart';
import 'package:lk_client/store/global/bloc_provider.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'app.dart';
import 'store/global/app_state_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appEnv = 'dev';
  final appConfig = await AppConfig.configure(env: appEnv);

  await Firebase.initializeApp();
  final firebaseMessaging = FirebaseMessaging.instance;
  await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  final hiveService = HiveService();
  final authData = AmqpAuthenticationData(
      rmqHost: appConfig.rmqHost,
      rmqPort: appConfig.rmqPort,
      rmqUsername: appConfig.rmqUsername,
      rmqVHost: appConfig.rmqVHost,
      rmqPassword: appConfig.rmqPassword);
  final amqpService = AmqpService(rmqAuthenticationData: authData);

  final stubErrorHandler = StubErrorHandler();
  final validationErrorHandler = ValidationErrorHandler(stubErrorHandler);
  final duplicateErrorHandler = DuplicateErrorHandler(validationErrorHandler);
  final notFoundErrorHandler = NotFoundErrorHandler(duplicateErrorHandler);
  final apiSystemErrorHandler = ApiSystemErrorHandler(notFoundErrorHandler);
  final accessDeniedErrorHandler =
      AccessDeniedErrorHandler(apiSystemErrorHandler);
  final dataAccessErrorHandler =
      DataAccessErrorHandler(accessDeniedErrorHandler);
  final apiErrorHandlersChain = new ErrorJudge(dataAccessErrorHandler);

  final appJwt = JwtManager.instance;
  final appApiEndpointConsumer = ApiEndpointConsumer(appConfig);

  final appAuthorizationService = AuthorizationService(
      appApiEndpointConsumer, apiErrorHandlersChain, appJwt);

  final appAuthenticationBloc = AuthenticationBloc(
      jwtManager: appJwt, authorizationService: appAuthorizationService);

  AuthenticationExtractor appAuthenticationExtractor =
      appAuthenticationBloc.authenticationExtractor;

  final appPersonQueryService = PersonQueryService(appApiEndpointConsumer,
      appAuthenticationExtractor, apiErrorHandlersChain);
  final appEducationQueryService = EducationQueryService(appApiEndpointConsumer,
      appAuthenticationExtractor, apiErrorHandlersChain);

  final appDisciplineQueryService = DisciplineQueryService(
      appApiEndpointConsumer,
      apiErrorHandlersChain,
      appAuthenticationExtractor);

  final appFileLocalManager = FileLocalManager();

  final appFileTransferManager = FileTransferManager(
      appConfig, appApiEndpointConsumer, appFileLocalManager);

  final appFileTransferService =
      FileTransferService(appFileTransferManager, appAuthenticationExtractor);

  final appMessengerQueryService = MessengerQueryService(
      apiEndpointConsumer: appApiEndpointConsumer,
      apiErrorHandler: apiErrorHandlersChain,
      authenticationExtractor: appAuthenticationExtractor);

  final appAchievementQueryService = AchievementQueryService(
      apiEndpointConsumer: appApiEndpointConsumer,
      authenticationExtractor: appAuthenticationExtractor,
      apiErrorHandler: apiErrorHandlersChain);

  final appUtilQueryService = UtilQueryService(
      apiEndpointConsumer: appApiEndpointConsumer,
      apiErrorHandler: apiErrorHandlersChain,
      authenticationExtractor: appAuthenticationExtractor);

  final applicationServiceProvider = ServiceProvider(
      disciplineQueryService: appDisciplineQueryService,
      appConfig: appConfig,
      fileTransferService: appFileTransferService,
      firebaseMessaging: firebaseMessaging,
      fileLocalManager: appFileLocalManager,
      fileTransferManager: appFileTransferManager,
      jwtManager: appJwt,
      authorizationService: appAuthorizationService,
      messengerQueryService: appMessengerQueryService,
      personQueryService: appPersonQueryService,
      achievementQueryService: appAchievementQueryService,
      utilQueryService: appUtilQueryService,
      educationQueryService: appEducationQueryService);

  appAuthenticationBloc.eventController.sink.add(AppStartedEvent());

  final appNavigationBloc = NavigationBloc();

  final appNotificationPrefsBloc =
      NotificationPrefsBloc(utilQueryService: appUtilQueryService);

  appNotificationPrefsBloc.eventController.sink
      .add(LoadNotificationPrefsEvent());

  final blocProvider = BlocProvider(
      authenticationBloc: appAuthenticationBloc,
      notificationPrefsBloc: appNotificationPrefsBloc,
      navigationBloc: appNavigationBloc);

  runApp(AppStateContainer(
      child: LkApp(appAuthorizationService),
      blocProvider: blocProvider,
      serviceProvider: applicationServiceProvider));
}
