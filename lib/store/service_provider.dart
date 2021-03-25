import 'package:flutter/foundation.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http/authorization_service.dart';
import 'package:lk_client/service/http/http_service.dart';
import 'package:lk_client/service/jwt_manager.dart';

class ServiceProvider {
  final JwtManager jwtManager;
  final AuthorizationService authorizationService;
  final AppConfig appConfig;

  ServiceProvider({
    @required this.jwtManager,
    @required this.authorizationService,
    @required this.appConfig
  });
}