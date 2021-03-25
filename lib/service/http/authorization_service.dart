import 'dart:html';

import 'package:lk_client/model/error/component_error_handler.dart';
import 'package:lk_client/model/request/identify_credentials.dart';
import 'package:lk_client/model/request/login_credentials.dart';
import 'package:lk_client/model/response/api_key.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http/http_service.dart';

class AuthorizationService extends HttpService {
  ComponentErrorHandler apiErrorHandler;

  AuthorizationService(AppConfig configuration, this.apiErrorHandler)
      : super(configuration);

  Future<ApiKey> authenticate(LoginCredentials user) async {
    HttpResponse response = await this.post('/auth', user.toJson());

    if (response.status == HttpStatus.created) {
      ApiKey token = ApiKey.fromJson(response.body);
      return token;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<ApiKey> identifyStudent(IdentifyCredentials credentials) async {
    HttpResponse response = await this.post('/identify', credentials.toJson());

    if (response.status == HttpStatus.ok) {
      ApiKey token = ApiKey.fromJson(response.body);
      return token;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<ApiKey> register(LoginCredentials user) async {
    HttpResponse response = await this.post('/reg', user.toJson());

    if (response.status == HttpStatus.created) {
      ApiKey token = ApiKey.fromJson(response.body);
      return token;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<ApiKey> updateJwt(ApiKey token) async {
    HttpResponse response = await this.post('/token/refresh', token.toJson());

    if (response.status == HttpStatus.ok) {
      ApiKey updatedToken = ApiKey.fromJson(response.body);
      return updatedToken;
    }

    throw apiErrorHandler.apply(response.body);
  }
}
