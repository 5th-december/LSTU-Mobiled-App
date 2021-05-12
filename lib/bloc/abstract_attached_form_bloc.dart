import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:lk_client/state/producing_state.dart';

class AttachedFileContent<T> {
  final T content;
  final LocalFilesystemObject file;
  AttachedFileContent({@required this.content,this.file});
}

/*
TQ - класс объекта метаданных
TR - класс объекта ответа 
TC - класс команды
*/
abstract class AbstractAttachedFormBloc<TQ, TR, TC>
  extends AbstractBloc<ProducingState, ProducingEvent> {
  Stream<ProducingState> get attachedFormStateStream =>
    this.stateContoller.stream.where((event) => event is ProducingState<TR>);

  Stream<ProducingEvent> get _attachedFormInitEventStream =>
    this.eventController.stream.where((event) => event is ProducerInitEvent<AttachedFileContent<TQ>>);

  Stream<ProducingEvent> get _attachedFormProduceEventStream => 
    this.eventController.stream.where((event) => event is ProduceResourceEvent<AttachedFileContent<TQ>, TC>);

  Stream<ProducingState<TQ>> sendFormData(TQ request, TC command);
  Stream<FileManagementState> sendMultipartData(LocalFilesystemObject loadingFile, TR argument);

  AbstractAttachedFormBloc() {
    this._attachedFormInitEventStream.listen((ProducingEvent event) {
      final _event = event as ProducerInitEvent<AttachedFileContent<TQ>>;
      this.updateState(ProducingInitState(initData: _event.resourse));
    });

    this._attachedFormProduceEventStream.listen((ProducingEvent event) {
      final _event = event as ProduceResourceEvent<AttachedFileContent<TQ>, TC>;

      TQ formData = _event.resourse.content;
      LocalFilesystemObject sendingFile = _event.resourse.file;
      TC command = _event.command;

      this.sendFormData(formData, command).listen((tEvent) {
        if (tEvent is ProducingInvalidState<TQ>) {
          this.updateState(ProducingInvalidState<TR>(tEvent.errorBox));
        } else if (tEvent is ProducingErrorState<TQ>) {
          this.updateState(ProducingErrorState<TQ>(tEvent.error));
        } else if (tEvent is ProducingReadyState<TQ, TR>) {
          if(sendingFile == null) {
            this.updateState(ProducingReadyState<AttachedFileContent<TQ>, TR>(data: _event.resourse, response: tEvent.response));
            return;
          }
          this.updateState(ProducingLoadingState<TQ>());
          TR fileRequestResponse = tEvent.response;
          this.sendMultipartData(sendingFile, fileRequestResponse).listen((fEvent) {
            if(fEvent is FileOperationErrorState) {
              this.updateState(ProducingErrorState<TQ>(fEvent.error));
            } else if (fEvent is FileUploadReadyState) {
              this.updateState(ProducingReadyState<AttachedFileContent<TQ>, TR>(data: _event.resourse, response: tEvent.response));
            } else {
              this.updateState(ProducingLoadingState<TR>());
            }
          });
        } else {
          this.updateState(ProducingLoadingState<TR>());
        }
      });
    });
  }
}