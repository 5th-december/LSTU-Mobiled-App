import 'package:flutter/foundation.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/caching/education_query_service.dart';
import 'package:lk_client/service/caching/person_query_service.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/service/http/http_service.dart';
import 'package:lk_client/service/jwt_manager.dart';

class ServiceProvider {
  final JwtManager jwtManager;
  final AuthorizationService authorizationService;
  final AppConfig appConfig;
  final PersonQueryService personQueryService;
  final EducationQueryService educationQueryService;

  ServiceProvider({
    @required this.jwtManager,
    @required this.authorizationService,
    @required this.appConfig,
    @required this.personQueryService,
    @required this.educationQueryService,
  });
}
