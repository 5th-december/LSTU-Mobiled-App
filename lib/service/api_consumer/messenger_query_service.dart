import 'package:flutter/foundation.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class MessengerQueryService {
  final ApiEndpointConsumer apiEndpointConsumer;
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;

  ApiKey get accessKey => this.authenticationExtractor.getAuthenticationData();

  MessengerQueryService({
    @required this.apiEndpointConsumer,
    @required this.apiErrorHandler,
    @required this.authenticationExtractor
  });

  Future<PrivateMessage> sendNewPrivateMessage(PrivateMessage message, String dialogId) async {
    HttpResponse response = await this.apiEndpointConsumer.post('/api/v1/messenger', 
        {'dialog': dialogId}, message.toJson(), this.accessKey.token);

    if(response.status == 201) {
      PrivateMessage createdMessage = PrivateMessage.fromJson(response.body);
      return createdMessage;
    }

    throw this.apiErrorHandler.apply(response.body);
  }

}