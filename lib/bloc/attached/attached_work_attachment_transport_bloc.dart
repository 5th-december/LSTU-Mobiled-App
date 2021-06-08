import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/attached/abstract_attached_transport_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/work_attachment_form_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:lk_client/state/producing_state.dart';

class AttachedWorkAttachmentTransportBloc extends AbstractAttachedTransportBloc<
    WorkAnswerAttachment, WorkAnswerAttachment, SendWorkAnswerAttachment> {
  final WorkAnswerAttachmentSendDocumentTransferBloc
      workAnswerAttachmentSendDocumentTransferBloc;

  final WorkAttachmentFormBloc workAttachmentFormBloc;

  AttachedWorkAttachmentTransportBloc(
      {@required this.workAnswerAttachmentSendDocumentTransferBloc,
      @required this.workAttachmentFormBloc});

  @override
  dispose() {
    this.workAttachmentFormBloc.dispose();
    this.workAnswerAttachmentSendDocumentTransferBloc.dispose();
    return super.dispose();
  }

  @override
  Stream<ProducingState<WorkAnswerAttachment>> sendFormData(
      WorkAnswerAttachment request, SendWorkAnswerAttachment command) {
    this.workAttachmentFormBloc.eventController.sink.add(
        ProduceResourceEvent<WorkAnswerAttachment, SendWorkAnswerAttachment>(
            command: command, resource: request));
    return this.workAttachmentFormBloc.resourseStateStream;
  }

  @override
  Stream<FileManagementState> sendMultipartData(
      LocalFilesystemObject loadingFile,
      WorkAnswerAttachment workAnswerAttachment) {
    this.workAnswerAttachmentSendDocumentTransferBloc.eventController.sink.add(
        FileStartUploadEvent<UploadWorkAnswerAttachment>(
            command: UploadWorkAnswerAttachment(
                workAnswerAttachment: workAnswerAttachment),
            file: loadingFile));
    return this
        .workAnswerAttachmentSendDocumentTransferBloc
        .binaryTransferStateStream;
  }
}
