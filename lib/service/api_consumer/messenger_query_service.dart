import 'package:flutter/foundation.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class MessengerQueryService {
  final ApiEndpointConsumer apiEndpointConsumer;
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;

  MessengerQueryService(
      {@required this.apiEndpointConsumer,
      @required this.apiErrorHandler,
      @required this.authenticationExtractor});

  Stream<ConsumingState<ListedResponse<PrivateMessage>>>
      getPrivateChatMessagesList(String dialogId,
          [String bound, String count]) async* {
    Map<String, String> request = <String, String>{'dialog': dialogId};

    if (bound != null) {
      request['iof'] = bound;
    }

    if (count != null) {
      request['ic'] = count;
    }

    String apiToken = await this.authenticationExtractor.getAuthenticationData;

    HttpResponse response = await this
        .apiEndpointConsumer
        .get('/api/v1/messenger/list', request, apiToken);

    if (response.status == 200) {
      ListedResponse<PrivateMessage> responseData =
          ListedResponse.fromJson(response.body, PrivateMessage.fromJson);
      yield ConsumingReadyState<ListedResponse<PrivateMessage>>(responseData);
    } else {
      yield ConsumingErrorState<ListedResponse<PrivateMessage>>(
          error: this.apiErrorHandler.apply(response.body));
    }
  }

  Stream<ConsumingState<ListedResponse<Dialog>>> getDialogList(
      [String bound, String count]) async* {
    final requestData = <String, String>{};
    if (bound != null) {
      requestData['iof'] = bound;
    }
    if (count != null) {
      requestData['ic'] = count;
    }
    HttpResponse response = await this.apiEndpointConsumer.get(
        '/api/v1/messenger/dialog/list',
        requestData,
        await this.authenticationExtractor.getAuthenticationData);

    if (response.status == 200) {
      ListedResponse<Dialog> dialogListData =
          ListedResponse.fromJson(response.body, Dialog.fromJson);
      yield ConsumingReadyState<ListedResponse<Dialog>>(dialogListData);
    } else {
      yield ConsumingErrorState<ListedResponse<Dialog>>(
          error: this.apiErrorHandler.apply(response.body));
    }
  }

  Future<PrivateMessage> sendNewPrivateMessage(
      PrivateMessage message, String dialogId) async {
    HttpResponse response = await this.apiEndpointConsumer.post(
        '/api/v1/messenger',
        {'dialog': dialogId},
        message.toJson(),
        await this.authenticationExtractor.getAuthenticationData);

    if (response.status == 201) {
      PrivateMessage createdMessage = PrivateMessage.fromJson(response.body);
      return createdMessage;
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Stream<ConsumingState<ListedResponse<DiscussionMessage>>>
      getDiscussionMessagesList(
          String disciplineId, String educationId, String semesterId,
          [String bound, String count]) async* {
    Map<String, String> arguments = <String, String>{
      'dis': disciplineId,
      'edu': educationId,
      'sem': semesterId,
    };

    if (bound != null) {
      arguments['iof'] = bound;
    }

    if (count != null) {
      arguments['ic'] = count;
    }

    String apiToken = await this.authenticationExtractor.getAuthenticationData;

    HttpResponse response = await this
        .apiEndpointConsumer
        .get('/api/v1/discussion/list', arguments, apiToken);

    if (response.status == 200) {
      ListedResponse<DiscussionMessage> discussionMessagedata =
          ListedResponse.fromJson(response.body, DiscussionMessage.fromJson);
      yield ConsumingReadyState<ListedResponse<DiscussionMessage>>(
          discussionMessagedata);
    } else {
      yield ConsumingErrorState<ListedResponse<DiscussionMessage>>(
          error: this.apiErrorHandler.apply(response.body));
    }
  }

  Future<DiscussionMessage> sendNewDiscussionMessage(
      DiscussionMessage discussionMessage,
      String educationId,
      String disciplineId,
      String semesterId) async {
    HttpResponse response = await this.apiEndpointConsumer.post(
        '/api/v1/discussion',
        {'edu': educationId, 'dis': disciplineId, 'sem': semesterId},
        discussionMessage.toJson(),
        await this.authenticationExtractor.getAuthenticationData);

    if (response.status == 201) {
      DiscussionMessage createdMessage =
          DiscussionMessage.fromJson(response.body);
      return createdMessage;
    }

    throw this.apiErrorHandler.apply(response.body);
  }

  Future<Dialog> createNewDialog(String companionId) async {
    HttpResponse response = await this.apiEndpointConsumer.post(
        '/api/v1/messenger/dialog',
        {'p': companionId},
        const {},
        await this.authenticationExtractor.getAuthenticationData);

    if (response.status == 201) {
      Dialog dialog = Dialog.fromJson(response.body);
      return dialog;
    }

    throw this.apiErrorHandler.apply(response.body);
  }
}
