import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/attached_form_state.dart';
import 'package:lk_client/widget/form/attached_private_messaging_form.dart';

abstract class AttachedFormInputPublisher<T> {
  Stream<AttachedFormInputState<T>> attachedInputStateStream;
}

class SingleTypeAttachementFormBloc<T>
    extends AbstractBloc<AttachedFormInputState<T>, AttachedFormInputEvent> {
  /*
   * Стрим состояний формы
   */
  Stream<AttachedFormInputState<T>> get attachedInputStateStream => this
      .stateContoller
      .stream
      .where((event) => event is AttachedFormInputState<T>);

  /*
   * Стрим событий инициализации формы
   */
  Stream<AttachedFormInputEvent> get _attachedInputInitEventStream => this
      .eventController
      .stream
      .where((event) => event is InitAttachedFormInputEvent);

  /*
   * Стрим событий добавления файла
   */
  Stream<AttachedFormInputEvent> get _attachedInputAddFileEventStream => this
      .eventController
      .stream
      .where((event) => event is AddFileAttachmentEvent);

  /*
   * Стрим событий добавления внешней ссылки
   */
  Stream<AttachedFormInputEvent> get _attachedInputAddExternalLinkEventStream =>
      this
          .eventController
          .stream
          .where((event) => event is AddExternalLinkEvent);

  /*
   * Стрим событий удаления файла
   */
  Stream<AttachedFormInputEvent> get _attachedInputRemoveFileEventStream => this
      .eventController
      .stream
      .where((event) => event is RemoveFileAttachmentEvent);

  /*
   * Стрим событий удаления внешней ссылки
   */
  Stream<AttachedFormInputEvent>
      get _attachedInputRemoveExternalLinkEventStream => this
          .eventController
          .stream
          .where((event) => event is RemoveExternalLinkEvent);

  /*
   * Стрим событий получения объекта из формы
   */
  Stream<AttachedFormInputEvent> get _prepareAttachedInputFormObject => this
      .eventController
      .stream
      .where((event) => event is PrepareFormObjectEvent);

  SingleTypeAttachementFormBloc(FormObjectBuilder<T> formObjectBuilder) {
    this._prepareAttachedInputFormObject.listen((event) {
      if (this.currentState == null) return;

      T formObject = formObjectBuilder.getFormObject();

      if (formObject != null) {
        this.updateState(ObjectReadyFormInputState<T>(
            attachedLink: this.currentState.attachedLink,
            fileAttachment: this.currentState.fileAttachment,
            formTypeInputObject: formObject));
      }
    });

    this._attachedInputInitEventStream.listen((event) {
      /*
       * Тут можно подтягивать ранее введенные и неотправленные данные
       */
      this.updateState(WaitUserInputState<T>());
      formObjectBuilder.clearFormObject();
    });

    this._attachedInputAddFileEventStream.listen((event) {
      final _event = event as AddFileAttachmentEvent;
      /*
       * Добавление файла возможно, если к сообщению ничего не добавлено
       */
      if (this.currentState != null &&
          this.currentState.fileAttachment == null &&
          this.currentState.attachedLink == null) {
        LocalFilesystemObject addedAttachment =
            LocalFilesystemObject.fromFilePath(_event.attachmentPath);
        this.updateState(WaitUserInputState<T>(
            fileAttachment: addedAttachment,
            formTypeInputObject: this.currentState.formTypeInputObject));
      }
    });

    this._attachedInputAddExternalLinkEventStream.listen((event) {
      final _event = event as AddExternalLinkEvent;
      /*
       * При отсутствии других вложений
       */
      if (this.currentState != null &&
          this.currentState.fileAttachment == null &&
          this.currentState.attachedLink == null) {
        ExternalLink addedLink = ExternalLink(
            linkContent: _event.extenalLinkContent,
            linkText: _event.externalLinkText);
        this.updateState(WaitUserInputState(
            attachedLink: addedLink,
            formTypeInputObject: this.currentState.formTypeInputObject));
      }
    });

    /*
     * Слушатели стримов сброса вложений
     */
    this._attachedInputRemoveFileEventStream.listen((event) {
      if (this.currentState != null &&
          this.currentState.fileAttachment != null) {
        this.updateState(WaitUserInputState(
            attachedLink: this.currentState.attachedLink,
            formTypeInputObject: this.currentState.formTypeInputObject));
      }
    });

    this._attachedInputRemoveExternalLinkEventStream.listen((event) {
      if (this.currentState != null && this.currentState.attachedLink != null) {
        this.updateState(WaitUserInputState(
            fileAttachment: this.currentState.fileAttachment,
            formTypeInputObject: this.currentState.formTypeInputObject));
      }
    });
  }
}
