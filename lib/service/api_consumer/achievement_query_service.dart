import 'package:lk_client/model/achievements/achievements_summary.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http/http_service.dart';

class AchievementQurtyService extends HttpService
{
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;

  ApiKey get accessKey => authenticationExtractor.getAuthenticationData();

  AchievementQurtyService(AppConfig config, this.authenticationExtractor, this.apiErrorHandler): super(config);

  /*Future<AchievementList> getAchievementList(String person, int offset, int count) async {
    HttpResponse response = await this.get('/api/v1/person/achievements', 
      <String, dynamic> {'p': person, 'of': offset, 'c': count}, this.accessKey.token);

    if(response.status == 200) {
      AchievementList personAchievements = AchievementList.fromJson(response.body);
      return personAchievements;
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<PublicationList> getPublicationsList(String person, int offset, int count) async {
    HttpResponse response = await this.get('/api/v1/publications', 
      <String, dynamic> {'p': person, 'of': offset, 'c': count}, this.accessKey.token);

    if(response.status == 200) {
      PublicationList personPublications = PublicationList.fromJson(response.body);
      return personPublications;
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<AchievementsSummary> getAchievementsSummary(String person) async {
    HttpResponse response = await this.get('/api/v1/person/achievements-summary', 
      <String, String>{'p': person}, this.accessKey.token);

    if(response.status == 200) {
      AchievementsSummary personAchievementsSummary = AchievementsSummary.fromJson(response.body);
      return personAchievementsSummary;
    }

    throw this.apiErrorHandler.apply(response.body);
  }*/
}