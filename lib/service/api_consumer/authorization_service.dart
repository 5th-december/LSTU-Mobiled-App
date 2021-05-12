import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/identify_credentials.dart';
import 'package:lk_client/model/authentication/login_credentials.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/service/jwt_manager.dart';

class AuthorizationService {
  final ComponentErrorHandler apiErrorHandler;
  final JwtManager appJwtManager;
  final ApiEndpointConsumer apiEndpointConsumer;

  AuthorizationService(this.apiEndpointConsumer, this.apiErrorHandler, this.appJwtManager);

  Future<ApiKey> authenticate(LoginCredentials user) async {
    HttpResponse response = await this.apiEndpointConsumer.post('api/v1/auth', {}, user.toJson());

    if (response.status == 200) {
      ApiKey token = ApiKey.fromJson(response.body);
      return token;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<ApiKey> identifyStudent(IdentifyCredentials credentials) async {
    HttpResponse response =
        await this.apiEndpointConsumer.post('api/v1/identify', {}, credentials.toJson());

    if (response.status == 200) {
      ApiKey token = ApiKey.fromJson(response.body);
      return token;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<ApiKey> register(LoginCredentials user) async {
    String jwtToken = await this.appJwtManager.getSavedJwt();
    HttpResponse response =
        await this.apiEndpointConsumer.post('api/v1/reg', {}, user.toJson(), jwtToken);

    if (response.status == 200) {
      ApiKey token = ApiKey.fromJson(response.body);
      return token;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<ApiKey> updateJwt(ApiKey token) async {
    HttpResponse response =
        await this.apiEndpointConsumer.post('/api/v1/token/refresh', {}, token.toJson());

    if (response.status == 200) {
      ApiKey updatedToken =
          ApiKey.fromJson(response.body);
      return updatedToken;
    }

    throw apiErrorHandler.apply(response.body);
  }
}
