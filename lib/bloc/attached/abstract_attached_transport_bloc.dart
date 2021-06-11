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
    this._attachedFormProduceEventStream.listen((ProducingEvent event) async {
      final _event = event as ProduceResourceEvent<AttachedFileContent<TQ>, TC>;
      TQ formData = _event.resourse.content;
      LocalFilesystemObject sendingFile = _event.resourse.file;
      TC command = _event.command;
      this.updateState(ProducingLoadingState<TQ>());

      final sendingStream = this.sendFormData(formData, command);

      TR formSendingResponse;

      await for (ProducingState<TQ> value in sendingStream) {
        if (value is ProducingInvalidState<TQ>) {
          this.updateState(ProducingInvalidState<TQ>(value.errorBox));
          break;
        } else if (value is ProducingErrorState<TQ>) {
          this.updateState(ProducingErrorState<TQ>(value.error));
          break;
        } else if (value is ProducingReadyState<TQ, TR>) {
          formSendingResponse = value.response;
          break;
        }
      }

      if (sendingFile == null) {
        this.updateState(ProducingReadyState<AttachedFileContent<TQ>, TR>(
            data: _event.resourse, response: formSendingResponse));
      } else {
        this.updateState(ProducingLoadingState<LocalFilesystemObject>());
        final fileSendingStream =
            this.sendMultipartData(sendingFile, formSendingResponse);
        await for (FileManagementState fileSendingStatus in fileSendingStream) {
          if (fileSendingStatus is FileOperationErrorState) {
            this.updateState(ProducingErrorState<LocalFilesystemObject>(
                fileSendingStatus.error));
            break;
          } else if (fileSendingStatus is FileUploadReadyState) {
            this.updateState(ProducingReadyState<AttachedFileContent<TQ>, TR>(
                data: _event.resourse, response: formSendingResponse));
            break;
          }
        }
      }
    });
  }
}
