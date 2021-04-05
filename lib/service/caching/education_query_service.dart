import 'dart:convert';

import 'package:lk_client/model/entity/education_entity.dart';
import 'package:lk_client/model/error/component_error_handler.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/http/http_service.dart';
import 'package:lk_client/service/jwt_manager.dart';

class EducationQueryService extends HttpService {
  ComponentErrorHandler apiErrorHandler;
  JwtManager appJwtManager;

  EducationQueryService(
      AppConfig configurator, this.appJwtManager, this.apiErrorHandler)
      : super(configurator);

  Future<List<EducationEntity>> getEducationsList(String person) async {
    String jwtToken = await this.appJwtManager.getSavedJwt();

    HttpResponse response = await this.get('/api/v1/student/edu/list',
        <String, String>{'person': person}, jwtToken);

    if (response.status == 200) {
      List<EducationEntity> educations = [];
    }
  }
}
