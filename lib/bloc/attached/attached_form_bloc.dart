import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/attached_form_state.dart';

class AttachedFormBloc
    extends AbstractBloc<AttachedInputState, AttachedInputEvent> {
  Stream<AttachedInputState> get attachedInputStateStream =>
      this.stateContoller.stream.where((event) => event is AttachedInputState);

  // Стрим событий инициализации формы
  Stream<AttachedInputEvent> get _attachedInputInitEventStream => this
      .eventController
      .stream
      .where((event) => event is InitAttachedInputEvent);

  // Стрим событий добавления файла
  Stream<AttachedInputEvent> get _attachedInputAddFileEventStream => this
      .eventController
      .stream
      .where((event) => event is AddFileAttachmentEvent);

  // Стрим событий добавления внешней ссылки
  Stream<AttachedInputEvent> get _attachedInputAddExternalLinkEventStream =>
      this
          .eventController
          .stream
          .where((event) => event is AddExternalLinkEvent);

  // Стрим событий удаления файла
  Stream<AttachedInputEvent> get _attachedInputRemoveFileEventStream => this
      .eventController
      .stream
      .where((event) => event is RemoveFileAttachmentEvent);

  // Стрим событий удаления внешней ссылки
  Stream<AttachedInputEvent> get _attachedInputRemoveExternalLinkEventStream =>
      this
          .eventController
          .stream
          .where((event) => event is RemoveExternalLinkEvent);

  AttachedFormBloc() {
    this._attachedInputInitEventStream.listen((event) {
      // Тут можно подтягивать ранее введенные и неотправленные данные
      this.updateState(NoAttachedDataState());
    });

    this._attachedInputAddFileEventStream.listen((event) {
      final _event = event as AddFileAttachmentEvent;
      // Добавление файла возможно, если к сообщению ничего не добавлено
      if (currentState is NoAttachedDataState) {
        LocalFilesystemObject addedAttachment =
            LocalFilesystemObject.fromFilePath(_event.attachmentPath);
        this.updateState(FileAttachedState(fileAttachment: addedAttachment));
      }
    });

    this._attachedInputAddExternalLinkEventStream.listen((event) {
      final _event = event as AddExternalLinkEvent;
      // При отсутствии других вложений
      if (currentState is NoAttachedDataState) {
        ExternalLink addedLink = ExternalLink(
            linkContent: _event.extenalLinkContent,
            linkText: _event.externalLinkText);
        this.updateState(LinkAttachedState(attachedLink: addedLink));
      }
    });

    this._attachedInputRemoveFileEventStream.listen((event) {
      if (currentState is FileAttachedState) {
        this.updateState(NoAttachedDataState());
      }
    });

    this._attachedInputRemoveExternalLinkEventStream.listen((event) {
      if (currentState is LinkAttachedState) {
        this.updateState(NoAttachedDataState());
      }
    });
  }
}
