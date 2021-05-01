import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/identify_credentials.dart';
import 'package:lk_client/model/authentication/login_credentials.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http/http_service.dart';
import 'package:lk_client/service/jwt_manager.dart';

class AuthorizationService extends HttpService {
  ComponentErrorHandler apiErrorHandler;
  JwtManager appJwtManager;

  AuthorizationService(
      AppConfig configuration, this.apiErrorHandler, this.appJwtManager)
      : super(configuration);

  Future<ApiKey> authenticate(LoginCredentials user) async {
    HttpResponse response = await this.post('api/v1/auth', user.toJson());

    if (response.status == 200) {
      ApiKey token = ApiKey.fromJson(response.body as Map<String, dynamic>);
      return token;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<ApiKey> identifyStudent(IdentifyCredentials credentials) async {
    HttpResponse response =
        await this.post('api/v1/identify', credentials.toJson());

    if (response.status == 200) {
      ApiKey token = ApiKey.fromJson(response.body as Map<String, dynamic>);
      return token;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<ApiKey> register(LoginCredentials user) async {
    String jwtToken = await this.appJwtManager.getSavedJwt();
    // TODO: обработка отсутствия токена в хранилище
    HttpResponse response =
        await this.post('api/v1/reg', user.toJson(), jwtToken);

    if (response.status == 200) {
      ApiKey token = ApiKey.fromJson(response.body as Map<String, dynamic>);
      return token;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<ApiKey> updateJwt(ApiKey token) async {
    HttpResponse response =
        await this.post('/api/v1/token/refresh', token.toJson());

    if (response.status == 200) {
      ApiKey updatedToken =
          ApiKey.fromJson(response.body as Map<String, dynamic>);
      return updatedToken;
    }

    throw apiErrorHandler.apply(response.body);
  }
}
