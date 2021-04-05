import 'package:lk_client/model/entity/person_entity.dart';
import 'package:lk_client/model/error/component_error_handler.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http/http_service.dart';

class PersonQueryService extends HttpService {
  ComponentErrorHandler apiErrorHandler;

  PersonQueryService(AppConfig config) : super(config);

  Future<PersonEntity> getPersonEntity(String personId) async {
    HttpResponse response =
        await this.get('/api/v1/person/props/' + personId, {}, jwtToken);

    if (response.status == 200) {
      PersonEntity person = PersonEntity.fromJson(response.body);
      return person;
    }

    throw apiErrorHandler.apply(response.body);
  }

  Future<PersonEntity> getCurrentPerson() async {
    HttpResponse response =
        await this.get('/api/v1/person/whoami', {}, jwtToken);

    if (response.status == 200) {
      PersonEntity person = PersonEntity.fromJson(response.body);
      return person;
    }

    throw apiErrorHandler.apply(response.body);
  }
}
