import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_form_bloc.dart';
import 'package:lk_client/command/produce_command/private_message_produce_command.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/validatable.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';

class PrivateMessageFormBloc extends 
  AbstractFormBloc<PrivateMessage, SendNewPrivateMessage, PrivateMessage>
{
  final MessengerQueryService messengerQueryService;

  PrivateMessageFormBloc({@required this.messengerQueryService});

  @override
  PrivateMessage createInitialFormData(PrivateMessage argument) {
    return argument;
  }

  @override
  Future<PrivateMessage> getResponse(PrivateMessage request, SendNewPrivateMessage command) async {
    return await this.messengerQueryService.sendNewPrivateMessage(request, command.dialog.id);
  }

  @override
  ValidationErrorBox validateEntity(PrivateMessage argument) {
    return argument.validate();
  }
}