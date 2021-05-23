import 'package:flutter/foundation.dart';
import 'package:lk_client/model/achievements/achievement.dart';
import 'package:lk_client/model/achievements/achievements_summary.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/achievements/publication.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class AchievementQueryService {
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;
  final ApiEndpointConsumer apiEndpointConsumer;

  ApiKey get accessKey => authenticationExtractor.getAuthenticationData();

  AchievementQueryService(
      {@required this.apiEndpointConsumer,
      @required this.authenticationExtractor,
      @required this.apiErrorHandler});

  Stream<ConsumingState<ListedResponse<Achievement>>> getAchievementList(
      String person,
      [int offset,
      int count]) async* {
    try {
      Map<String, String> arguments = <String, String>{'p': person};
      if (offset != null) {
        arguments['of'] = offset.toString();
      }
      if (count != null) {
        arguments['c'] = count.toString();
      }
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/person/achievements/list', arguments, this.accessKey.token);

      if (response.status == 200) {
        ListedResponse<Achievement> personAchievements =
            ListedResponse.fromJson(response.body, Achievement.fromJson);
        yield ConsumingReadyState<ListedResponse<Achievement>>(
            personAchievements);
      } else {
        yield ConsumingErrorState<ListedResponse<Achievement>>(
            error: this.apiErrorHandler.apply(response.body));
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<Achievement>>(error: e);
    }
  }

  Stream<ConsumingState<ListedResponse<Publication>>> getPublicationsList(
      String person,
      [int offset,
      int count]) async* {
    try {
      Map<String, String> arguments = <String, String>{'p': person};
      if (offset != null) {
        arguments['of'] = offset.toString();
      }
      if (count != null) {
        arguments['c'] = count.toString();
      }
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/person/publications/list', arguments, this.accessKey.token);

      if (response.status == 200) {
        ListedResponse<Publication> personPublications =
            ListedResponse.fromJson(response.body, Publication.fromJson);
        yield ConsumingReadyState<ListedResponse<Publication>>(
            personPublications);
      } else {
        yield ConsumingErrorState<ListedResponse<Publication>>(
            error: this.apiErrorHandler.apply(response.body));
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<Publication>>(error: e);
    }
  }

  Stream<ConsumingState<AchievementsSummary>> getAchievementsSummary(
      String person) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/person/achievements/summary',
          <String, String>{'p': person},
          this.accessKey.token);

      if (response.status == 200) {
        AchievementsSummary personAchievementsSummary =
            AchievementsSummary.fromJson(response.body);
        yield ConsumingReadyState<AchievementsSummary>(
            personAchievementsSummary);
      } else {
        yield ConsumingErrorState<AchievementsSummary>(
            error: this.apiErrorHandler.apply(response.body));
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<AchievementsSummary>(error: e);
    }
  }
}
