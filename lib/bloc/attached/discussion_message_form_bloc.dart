import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/attached/abstract_form_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/validatable.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';

class DiscussionMessageFormBloc extends AbstractFormBloc<DiscussionMessage,
    SendNewDiscussionMessage, DiscussionMessage> {
  final MessengerQueryService messengerQueryService;

  DiscussionMessageFormBloc({@required this.messengerQueryService});

  @override
  DiscussionMessage createInitialFormData(DiscussionMessage argument) {
    return argument;
  }

  @override
  Future<DiscussionMessage> getResponse(
      DiscussionMessage request, SendNewDiscussionMessage command) async {
    return await this.messengerQueryService.sendNewDiscussionMessage(request,
        command.education.id, command.discipline.id, command.semester.id);
  }

  @override
  ValidationErrorBox validateEntity(DiscussionMessage argument) {
    return argument.validate();
  }
}
