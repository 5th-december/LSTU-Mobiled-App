import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/model/error/component_error_handler.dart';
import 'package:lk_client/model/response/api_key.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http/http_service.dart';

class PersonQueryService extends HttpService {
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;

  PersonQueryService(
      AppConfig config, this.authenticationExtractor, this.apiErrorHandler)
      : super(config);

  Future<PersonEntity> getPersonEntity(String personId) async {
    ApiKey key = authenticationExtractor.getAuthenticationData();

    HttpResponse response =
        await this.get('/api/v1/person/props/' + personId, {}, key.token);

    if (response.status == 200) {
      PersonEntity person =
          PersonEntity.fromJson(response.body as Map<String, dynamic>);
      return person;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<PersonEntity> getCurrentPerson() async {
    ApiKey key = authenticationExtractor.getAuthenticationData();

    HttpResponse response =
        await this.get('/api/v1/person/whoami', {}, key.token);

    if (response.status == 200) {
      PersonEntity person =
          PersonEntity.fromJson(response.body as Map<String, dynamic>);
      return person;
    }

    throw apiErrorHandler.apply(response.body);
  }
}
