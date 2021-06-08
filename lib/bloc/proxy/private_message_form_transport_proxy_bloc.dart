import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/attached/abstract_attached_transport_bloc.dart';
import 'package:lk_client/bloc/attached/attached_private_message_transport_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/private_message_form_bloc.dart';
import 'package:lk_client/bloc/proxy/abstract_attached_form_transport_proxy_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/util/attached_file_content.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/state/attached_form_state.dart';
import 'package:lk_client/state/producing_state.dart';

class PrivateMessageFormTransportProxyBloc
    extends AbstractAttachedFormTransportProxyBloc<PrivateMessage,
        SendNewPrivateMessage> {
  final FileTransferService fileTransferService;
  final MessengerQueryService messengerQueryService;
  PrivateMessageFormTransportProxyBloc(
      {@required this.fileTransferService,
      @required this.messengerQueryService,
      @required attachmentBlocProvider,
      @required sendingCommand,
      @required formBloc})
      : super(
            attachedBlocProvider: attachmentBlocProvider,
            sendingCommand: sendingCommand,
            formBloc: formBloc);

  @override
  String getStorageKey(SendNewPrivateMessage command) {
    return command.dialog.id;
  }

  @override
  AbstractAttachedTransportBloc<PrivateMessage, PrivateMessage,
      SendNewPrivateMessage> initTransport() {
    return AttachedPrivateMessageTransportBloc(
        privateMessageDocumentTransferBloc:
            PrivateMessageSendDocumentTransferBloc(
                fileTransferService: this.fileTransferService),
        privateMessageFormBloc: PrivateMessageFormBloc(
            messengerQueryService: this.messengerQueryService));
  }

  @override
  AttachedFormExternalInitEvent<PrivateMessage>
      transformAttachedContentToFormTypeCommand(
          ProducingState<PrivateMessage> attachedContent) {
    return AttachedFormExternalInitEvent<PrivateMessage>(
        attachedLink: attachedContent.data.links != null &&
                attachedContent.data.links.length != 0
            ? attachedContent.data.links[0]
            : null,
        initialFormDataObject: attachedContent.data);
    // TODO: Нет добавление отправляемых файлов
  }

  @override
  AttachedFileContent<PrivateMessage> transformFormTypeToAttachedContent(
      ObjectReadyFormInputState<PrivateMessage> fileObjectData) {
    List<ExternalLink> messageLinks = <ExternalLink>[];
    if (fileObjectData.attachedLink != null) {
      messageLinks.add(fileObjectData.attachedLink);
    }
    LocalFilesystemObject filesystemObject;
    if (fileObjectData.fileAttachment != null) {
      filesystemObject = fileObjectData.fileAttachment;
    }
    final message = PrivateMessage(
        messageText: fileObjectData.formTypeInputObject.messageText,
        links: messageLinks.length != 0 ? messageLinks : null);
    return AttachedFileContent<PrivateMessage>(
        content: message, file: filesystemObject);
  }
}
