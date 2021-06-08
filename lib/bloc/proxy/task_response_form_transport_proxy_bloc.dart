import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/attached/abstract_attached_transport_bloc.dart';
import 'package:lk_client/bloc/attached/attached_work_attachment_transport_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/work_attachment_form_bloc.dart';
import 'package:lk_client/bloc/proxy/abstract_attached_form_transport_proxy_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';
import 'package:lk_client/model/util/attached_file_content.dart';
import 'package:lk_client/state/attached_form_state.dart';
import 'package:lk_client/state/producing_state.dart';

class TaskResponseFormTransportProxyBloc
    extends AbstractAttachedFormTransportProxyBloc<WorkAnswerAttachment,
        SendWorkAnswerAttachment> {
  final WorkAnswerAttachmentSendDocumentTransferBloc
      workAnswerAttachmentSendDocumentTransferBloc;
  final WorkAttachmentFormBloc workAttachmentFormBloc;

  TaskResponseFormTransportProxyBloc(
      {@required this.workAnswerAttachmentSendDocumentTransferBloc,
      @required this.workAttachmentFormBloc,
      @required attachedBlocProvider,
      @required sendingCommand,
      @required formBloc})
      : super(
            attachedBlocProvider: attachedBlocProvider,
            sendingCommand: sendingCommand,
            formBloc: formBloc);

  @override
  AbstractAttachedTransportBloc<WorkAnswerAttachment, WorkAnswerAttachment,
      SendWorkAnswerAttachment> initTransport() {
    return AttachedWorkAttachmentTransportBloc(
        workAnswerAttachmentSendDocumentTransferBloc:
            workAnswerAttachmentSendDocumentTransferBloc,
        workAttachmentFormBloc: workAttachmentFormBloc);
  }

  @override
  String getStorageKey(SendWorkAnswerAttachment command) {
    return command.studentWork.id;
  }

  @override
  AttachedFileContent<WorkAnswerAttachment> transformFormTypeToAttachedContent(
      ObjectReadyFormInputState<WorkAnswerAttachment> fileObjectData) {
    final workAnswer = WorkAnswerAttachment(
        name: fileObjectData.formTypeInputObject.name,
        extLinks: fileObjectData.attachedLink != null
            ? <ExternalLink>[fileObjectData.attachedLink]
            : null);

    return AttachedFileContent<WorkAnswerAttachment>(
        content: workAnswer, file: fileObjectData.fileAttachment);
  }

  @override
  AttachedFormExternalInitEvent<WorkAnswerAttachment>
      transformAttachedContentToFormTypeCommand(
          ProducingState<WorkAnswerAttachment> attachedContent) {
    return AttachedFormExternalInitEvent(
        initialFormDataObject: attachedContent.data,
        attachedLink: attachedContent.data.extLinks != null &&
                attachedContent.data.extLinks.length != 0
            ? attachedContent.data.extLinks[0]
            : null);
    // TODO: Добавление файлов при восстановлении формы
  }
}
