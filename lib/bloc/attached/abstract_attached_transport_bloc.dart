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
    this._attachedFormProduceEventStream.listen((ProducingEvent event) {
      /*
       * Отправка доступна, если в текущий момент нет других отправляемых сообщений
       *
      if (this.currentState is ProducingLoadingState) {
        return;
      }*/
      final _event = event as ProduceResourceEvent<AttachedFileContent<TQ>, TC>;

      /*
       * Объект данных формы
       */
      TQ formData = _event.resourse.content;

      /*
       * Прикрепленный файл
       */
      LocalFilesystemObject sendingFile = _event.resourse.file;

      /*
       * Команда отправки формы
       */
      TC command = _event.command;

      /*
       * Вызов переопределенного метода отправки данных формы, добавление листенера ответов
       */
      this.updateState(ProducingLoadingState<TQ>());

      this.sendFormData(formData, command).listen((tEvent) {
        if (tEvent is ProducingInvalidState<TQ>) {
          /**
           * В случае, если введенные в форме данные не валидны
           * Такое состояние может быть отправлено из апи
           */
          this.updateState(ProducingInvalidState<TQ>(tEvent.errorBox));
        } else if (tEvent is ProducingErrorState<TQ>) {
          /**
           * Ошибка отправки формы
           */
          this.updateState(ProducingErrorState<TQ>(tEvent.error));
        } else if (tEvent is ProducingReadyState<TQ, TR>) {
          /*
           * Успешная отправка формы
           * В случае, если нет прикрепленного медиа файла, возвращается ready state
           */
          if (sendingFile == null) {
            this.updateState(ProducingReadyState<AttachedFileContent<TQ>, TR>(
                data: _event.resourse, response: tEvent.response));
            return;
          }

          this.updateState(ProducingLoadingState<LocalFilesystemObject>());

          /*
           * Получение идентификатора добавленного объекта из формы
           */
          TR fileRequestResponse = tEvent.response;

          /*
           * Вызов переопределенного метода отправки медиа, добавление листенера 
           */
          this.sendMultipartData(sendingFile, fileRequestResponse).listen(
              (fEvent) {
            if (fEvent is FileOperationErrorState) {
              /**
                * Ошибка отправки медиа данных
                */
              this.updateState(
                  ProducingErrorState<LocalFilesystemObject>(fEvent.error));
            } else if (fEvent is FileUploadReadyState) {
              /**
                 * Успешная отправка медиа данных
                 */
              this.updateState(ProducingReadyState<AttachedFileContent<TQ>, TR>(
                  data: _event.resourse, response: tEvent.response));
            }
          }, onError: (e) {
            this.updateState(ProducingErrorState<LocalFilesystemObject>(e));
          });
        }
      }, onError: (e) {
        this.updateState(ProducingErrorState<TQ>(e));
      });
    });
  }
}
