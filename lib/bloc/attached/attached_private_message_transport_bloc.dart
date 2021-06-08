import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/attached/abstract_attached_transport_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/private_message_form_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:lk_client/state/producing_state.dart';

class AttachedPrivateMessageTransportBloc extends AbstractAttachedTransportBloc<
    PrivateMessage, PrivateMessage, SendNewPrivateMessage> {
  final PrivateMessageFormBloc privateMessageFormBloc;
  final PrivateMessageSendDocumentTransferBloc
      privateMessageDocumentTransferBloc;

  AttachedPrivateMessageTransportBloc(
      {@required this.privateMessageDocumentTransferBloc,
      @required this.privateMessageFormBloc});

  @override
  dispose() {
    this.privateMessageDocumentTransferBloc.dispose();
    this.privateMessageFormBloc.dispose();
    return super.dispose();
  }

  @override
  Stream<ProducingState<PrivateMessage>> sendFormData(
      PrivateMessage request, SendNewPrivateMessage command) {
    this.privateMessageFormBloc.eventController.sink.add(
        ProduceResourceEvent<PrivateMessage, SendNewPrivateMessage>(
            resource: request, command: command));
    return this.privateMessageFormBloc.resourseStateStream;
  }

  @override
  Stream<FileManagementState> sendMultipartData(
      LocalFilesystemObject loadingFile, PrivateMessage argument) {
    this.privateMessageDocumentTransferBloc.eventController.sink.add(
        FileStartUploadEvent<UploadPrivateMessageAttachment>(
            file: loadingFile,
            command: UploadPrivateMessageAttachment(message: argument)));
    return this.privateMessageDocumentTransferBloc.binaryTransferStateStream;
  }
}
