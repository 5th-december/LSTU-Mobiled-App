import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_attached_form_bloc.dart';
import 'package:lk_client/bloc/discussion_message_form_bloc.dart';
import 'package:lk_client/bloc/file_transfer_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/file_management_event.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:lk_client/state/producing_state.dart';

class AttachedDiscussionFormBloc extends AbstractAttachedFormBloc
  <DiscussionMessage, DiscussionMessage, SendNewDiscussionMessage> {

  final DiscussionMessageFormBloc discussionMessageFormBloc;
  final DiscussionMessageSendDocumentTransferBloc discussionMessageSendDocumentTransferBloc;

  AttachedDiscussionFormBloc({
    @required this.discussionMessageFormBloc,
    @required this.discussionMessageSendDocumentTransferBloc
  });

  @override
  dispose() {
    this.discussionMessageSendDocumentTransferBloc.dispose();
    this.discussionMessageFormBloc.dispose();
    return super.dispose();
  }

  @override
  Stream<ProducingState<DiscussionMessage>> sendFormData(DiscussionMessage request, SendNewDiscussionMessage command) {
    this.discussionMessageFormBloc.eventController.sink.add(
      ProduceResourceEvent<DiscussionMessage, SendNewDiscussionMessage>(command: command, resource: request));
    return this.discussionMessageFormBloc.resourseStateStream;
  }

  @override
  Stream<FileManagementState> sendMultipartData(LocalFilesystemObject loadingFile, DiscussionMessage argument) {
    this.discussionMessageSendDocumentTransferBloc.eventController.sink.add(
      FileFindLocallyEvent(file: loadingFile));

    this.discussionMessageSendDocumentTransferBloc.binaryTransferStateStream.listen((event) {
      if(event is FileLocatedState) {
        this.discussionMessageSendDocumentTransferBloc.eventController.sink.add(
          FileStartUploadEvent<UploadDiscussionMessageAttachment>(
            command: UploadDiscussionMessageAttachment(message: argument),
            file: loadingFile
          )
        );
      }
    });

    return this.discussionMessageSendDocumentTransferBloc.binaryTransferStateStream;
  }
}