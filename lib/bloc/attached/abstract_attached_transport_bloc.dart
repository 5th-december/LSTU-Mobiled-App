import 'dart:async';

import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/util/attached_file_content.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/file_management_state.dart';
import 'package:lk_client/state/producing_state.dart';

/*
 * TR - объект ответа на запрос отправки формы
 * TQ - объект данных формы
 * TC - объект команды отправки формы
 */
abstract class AbstractAttachedTransportBloc<TQ, TR, TC>
    extends AbstractBloc<ProducingState, ProducingEvent> {
  /*
   * Прозводный класс должен сам определять блоки для отправки 
   * данных формы, унаследованный от AbstractFormBloc 
   * и для отправки медиа, унаследованный от AbstractFileTransferBloc
   * 
   * Возвращает следующие state:
   * 1) При отправке данных формы добавляется ProducingState<TQ>
   * 2) При отправке медиа данных добавляется ProducingState<LocalFilesystemObject>
   * 3) При успешной отправке добавляется ProducingReadyState<AttachedFileContent<TQ>, TR>,
   *    содерж. ответ полученный при отправке формы (TR) и первоначальный отправляемый объект данных 
   */
  Stream<ProducingState> get attachedFormStateStream => this
      .stateContoller
      .stream
      .where((event) => event is ProducingState<dynamic>);

  Stream<ProducingEvent> get _attachedFormInitEventStream =>
      this.eventController.stream.where((event) => event is ProducerInitEvent);

  Stream<ProducingEvent> get _attachedFormProduceEventStream =>
      this.eventController.stream.where((event) =>
          event is ProduceResourceEvent<AttachedFileContent<TQ>, TC>);

  /*
   * Добавляет событие отправки данных формы в определяемый производным классом блок
   */
  Stream<ProducingState<TQ>> sendFormData(TQ request, TC command);

  /*
   * Добавляет событие отправки медиа в определяемый производным классом блок
   */
  Stream<FileManagementState> sendMultipartData(
      LocalFilesystemObject loadingFile, TR argument);

  Future<ProducingState> sendAttachedFileForm(
      AttachedFileContent<TQ> data, TC command) async {
    Completer<ProducingState> completer = Completer<ProducingState>();

    final sendingStream = await this.sendFormData(data.content, command);

    TR formSendingResponse;

    await for (ProducingState<TQ> value in sendingStream) {
      if (value is ProducingInvalidState<TQ>) {
        completer.completeError(ProducingInvalidState<TQ>(value.errorBox));
        break;
      } else if (value is ProducingErrorState<TQ>) {
        completer.completeError(ProducingErrorState<TQ>(value.error));
        break;
      } else if (value is ProducingReadyState<TQ, TR>) {
        formSendingResponse = value.response;
        break;
      }
    }

    if (data.file == null) {
      completer.complete(ProducingReadyState<AttachedFileContent<TQ>, TR>(
          data: data, response: formSendingResponse));
    } else {
      final fileSendingStream =
          this.sendMultipartData(data.file, formSendingResponse);
      await for (FileManagementState fileSendingStatus in fileSendingStream) {
        if (fileSendingStatus is FileOperationErrorState) {
          completer.completeError(ProducingErrorState<LocalFilesystemObject>(
              fileSendingStatus.error));
          break;
        } else if (fileSendingStatus is FileUploadReadyState) {
          completer.complete(ProducingReadyState<AttachedFileContent<TQ>, TR>(
              data: data, response: formSendingResponse));
          break;
        }
      }
    }

    return completer.future;
  }

  AbstractAttachedTransportBloc() {
    /*
    * Событие первичной инициализация формы
    */
    this._attachedFormInitEventStream.listen((ProducingEvent event) {
      /**
       * Первичная инициализация данных формы
       */
      this.updateState(ProducingInitState<TQ>());
    });

    /*
    * Событие отправки данных формы
    */
    this._attachedFormProduceEventStream.listen((ProducingEvent event) {
      final _event = event as ProduceResourceEvent<AttachedFileContent<TQ>, TC>;
      this
          .sendAttachedFileForm(_event.resourse, _event.command)
          .then((value) => this.updateState(value))
          .catchError((e) => this.updateState(e));
    });
  }
}
