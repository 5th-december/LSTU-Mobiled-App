import 'package:flutter/foundation.dart';
import 'package:lk_client/service/api_consumer/education_query_service.dart';
import 'package:lk_client/service/api_consumer/person_query_service.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/service/jwt_manager.dart';

class ServiceProvider {
  final JwtManager jwtManager;
  final AuthorizationService authorizationService;
  final AppConfig appConfig;
  final PersonQueryService personQueryService;
  final EducationQueryService educationQueryService;
  final AuthenticationExtractor authenticationExtractor;

  ServiceProvider({
    @required this.jwtManager,
    @required this.authorizationService,
    @required this.appConfig,
    @required this.personQueryService,
    @required this.educationQueryService,
    @required this.authenticationExtractor,
  });
}
