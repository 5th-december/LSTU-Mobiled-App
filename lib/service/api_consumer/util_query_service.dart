import 'package:flutter/foundation.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/group.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/util/fcm_key.dart';
import 'package:lk_client/model/util/notification_preferences.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http_service.dart';

class UtilQueryService {
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;
  final ApiEndpointConsumer apiEndpointConsumer;

  UtilQueryService(
      {@required this.apiEndpointConsumer,
      @required this.apiErrorHandler,
      @required this.authenticationExtractor});

  Future<bool> addDeviceFcmKey(FcmKey fcmKey) async {
    HttpResponse response = await this.apiEndpointConsumer.post(
        '/api/v1/notifications/device',
        {},
        fcmKey.toJson(),
        await this.authenticationExtractor.getAuthenticationData);

    if (response.status == 200) {
      return true;
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<bool> revokeDeviceFcmKey(FcmKey fcmKey) async {
    HttpResponse response = await this.apiEndpointConsumer.delete(
        '/api/v1/notifications/device',
        {},
        fcmKey.toJson(),
        await this.authenticationExtractor.getAuthenticationData);

    if (response.status == 200) {
      return true;
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<NotificationPreferences> changeNotificationPreferences(
      NotificationPreferences preferences) async {
    HttpResponse response = await this.apiEndpointConsumer.patch(
        '/api/v1/notifications/prefs',
        {},
        preferences.toJson(),
        await this.authenticationExtractor.getAuthenticationData);

    if (response.status == 200) {
      return NotificationPreferences.fromJson(response.body);
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<NotificationPreferences> getCurrentNotificationPreferences() async {
    String apiToken = await this.authenticationExtractor.getAuthenticationData;

    HttpResponse response = await this
        .apiEndpointConsumer
        .get('/api/v1/notifications/prefs', {}, apiToken);

    if (response.status == 200) {
      return NotificationPreferences.fromJson(response.body);
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<Person> getCurrentPersonIdentifier() async {
    final apiToken = await this.authenticationExtractor.getAuthenticationData;

    HttpResponse response =
        await this.apiEndpointConsumer.get('/api/v1/whoami', {}, apiToken);

    if (response.status == 200) {
      return Person.fromJson(response.body);
    }
    throw apiErrorHandler.apply(response.body);
  }

  Future<ListedResponse<Dialog>> getDialogIdentifiersFullList() async {
    final apiToken = await this.authenticationExtractor.getAuthenticationData;

    HttpResponse response = await this
        .apiEndpointConsumer
        .get('/api/v1/messenger/dialog/ids/list', {}, apiToken);

    if (response.status == 200) {
      return ListedResponse.fromJson(response.body, Dialog.fromJson);
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<ListedResponse<Group>> getGroupsFullList() async {
    final apiToken = await this.authenticationExtractor.getAuthenticationData;

    HttpResponse response = await this
        .apiEndpointConsumer
        .get('/api/v1/student/edu/groups/ids/list', {}, apiToken);

    if (response.status == 200) {
      return ListedResponse.fromJson(response.body, Group.fromJson);
    }

    throw this.apiErrorHandler.apply(response.body);
  }
}
