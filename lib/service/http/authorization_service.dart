import 'package:lk_client/exception/api_exception.dart';
import 'package:lk_client/exception/business_logic_exception.dart';
import 'package:lk_client/model/request/user_identify_credentials.dart';
import 'package:lk_client/model/request/user_register_credentials.dart';
import 'package:lk_client/model/request/user_login_credentials.dart';
import 'package:lk_client/model/response/business_logic_error.dart';
import 'package:lk_client/model/response/jwt_token.dart';
import 'package:lk_client/model/response/student_identifier.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http/http_service.dart';

class AuthorizationService extends HttpService
{
  AuthorizationService(AppConfig configuration): super(configuration);

  Future<JwtToken> authenticate(UserLoginCredentials user) async {
    try {
      HttpResponse response = await this.post('/auth', user.toJson());

      if (response.status == 201) {
        JwtToken token = JwtToken.fromJson(response.body);
        return token;
      }

      if (response.status == 401 && response.body['logic'] != null) {
        BusinessLogicError businessLogicError = BusinessLogicError.fromJson(response.body['logic']);
        throw BusinessLogicException(error: businessLogicError);
      }

      // log response here
      throw ApiException();

    } on ApiException {
      rethrow;
    }
  }

  Future<StudentIdentifier> identifyStudent(UserIdentifyCredentials credentials) async {
    try {
      HttpResponse response = await this.post('/identify', credentials.toJson());

      if (response.status == 200) {
        StudentIdentifier studentIdentifier = StudentIdentifier.fromJson(response.body);
        return studentIdentifier;
      }

      if (response.status == 404 && response.body['logic'] != null) {
        BusinessLogicError businessLogicError = BusinessLogicError.fromJson(response.body['logic']);
        throw BusinessLogicException(error: businessLogicError);
      }

      // log response here
      throw ApiException();

    } on ApiException {
      rethrow;
    }
  }

  Future<JwtToken> register(UserRegisterCredentials user) async {
    try {
      HttpResponse response = await this.post('/register', user.toJson());

      if (response.status == 201) {
        JwtToken token = JwtToken.fromJson(response.body);
        return token;
      }

      if (response.status == 400 && response.body['logic'] != null) {
        BusinessLogicError businessLogicError = BusinessLogicError.fromJson(response.body['logic']);
        throw BusinessLogicException(error: businessLogicError);
      }

      // log response here
      throw ApiException();

    } on ApiException {
      rethrow;
    }
  }

  Future<JwtToken> updateJwt(JwtToken token) async {
    try {
      HttpResponse response = await this.post('/update-jwt', token.toJson());
      if (response.status == 200) {
        JwtToken updatedToken = JwtToken.fromJson(response.body);
        return updatedToken;
      }
    } on ApiException {
      rethrow;
    }
  }


}