import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/attached/abstract_attached_transport_bloc.dart';
import 'package:lk_client/bloc/attached/attached_discussion_transport_bloc.dart';
import 'package:lk_client/bloc/attached/discussion_message_form_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/proxy/abstract_attached_form_transport_proxy_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/util/attached_file_content.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/state/attached_form_state.dart';
import 'package:lk_client/state/producing_state.dart';

class DiscussionMessageFormTransportProxyBloc
    extends AbstractAttachedFormTransportProxyBloc<DiscussionMessage,
        SendNewDiscussionMessage> {
  final MessengerQueryService messengerQueryService;

  final FileTransferService fileTransferService;

  DiscussionMessageFormTransportProxyBloc(
      {@required this.messengerQueryService,
      @required this.fileTransferService,
      @required attachmentBlocProvider,
      @required sendingCommand,
      @required formBloc})
      : super(
            attachedBlocProvider: attachmentBlocProvider,
            sendingCommand: sendingCommand,
            formBloc: formBloc);
  @override
  String getStorageKey(SendNewDiscussionMessage command) {
    return "${command.discipline}.${command.education}.${command.semester}";
  }

  @override
  AbstractAttachedTransportBloc<DiscussionMessage, DiscussionMessage,
      SendNewDiscussionMessage> initTransport() {
    return AttachedDiscussionTransportBloc(
        discussionMessageFormBloc: DiscussionMessageFormBloc(
            messengerQueryService: this.messengerQueryService),
        discussionMessageSendDocumentTransferBloc:
            DiscussionMessageSendDocumentTransferBloc(
                fileTransferService: this.fileTransferService));
  }

  @override
  AttachedFormExternalInitEvent<DiscussionMessage>
      transformAttachedContentToFormTypeCommand(
          ProducingState<DiscussionMessage> attachedContent) {
    return AttachedFormExternalInitEvent(
        attachedLink: attachedContent.data.externalLinks != null &&
                attachedContent.data.externalLinks.length != 0
            ? attachedContent.data.externalLinks[0]
            : null,
        initialFormDataObject: attachedContent.data);
    // TODO: Добавлять прикрепленный файл
  }

  @override
  AttachedFileContent<DiscussionMessage> transformFormTypeToAttachedContent(
      ObjectReadyFormInputState<DiscussionMessage> fileObjectData) {
    final message = DiscussionMessage(
        msg: fileObjectData.formTypeInputObject.msg,
        externalLinks: fileObjectData.attachedLink != null
            ? <ExternalLink>[fileObjectData.attachedLink]
            : null);
    return AttachedFileContent<DiscussionMessage>(
        content: message, file: fileObjectData.fileAttachment);
  }
}
