import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/attached/abstract_attached_transport_bloc.dart';
import 'package:lk_client/bloc/attached/single_type_attachment_form_bloc.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/util/attached_file_content.dart';
import 'package:lk_client/state/attached_form_state.dart';
import 'package:lk_client/state/producing_state.dart';
import 'package:lk_client/store/global/attached_bloc_provider.dart';

/*
 * Прокси блок используется для инициализации транспортного блока для формы
 * он передается в виджет формы и инициализирует либо находит в провайдере транспортный блок 
 * Порождаемые подклассы должны реализовывть метод создания транспортного блока 
 * типа Abstract attached transport bloc
 */
abstract class AbstractAttachedFormTransportProxyBloc<T, C>
    extends AbstractBloc<dynamic, dynamic> {
  Stream<dynamic> get attachedFormStateStream => this.stateContoller.stream;

  Stream<dynamic> get _attachedFormEventStream => this.eventController.stream;

  AbstractAttachedTransportBloc<T, T, C> _transportBloc;

  AbstractAttachedTransportBloc<T, T, C> initTransport();

  AttachedFileContent<T> transformFormTypeToAttachedContent(
      ObjectReadyFormInputState<T> fileObjectData);

  AttachedFormExternalInitEvent<T> transformAttachedContentToFormTypeCommand(
      ProducingState<T> attachedContent);

  String getStorageKey(C command);

  AbstractAttachedFormTransportProxyBloc(
      {@required AttachedBlocProvider attachedBlocProvider,
      @required C sendingCommand,
      @required SingleTypeAttachementFormBloc<T> formBloc}) {
    AbstractAttachedTransportBloc existingTransportBloc = attachedBlocProvider
        .getAttachedTransportBloc(this.getStorageKey(sendingCommand));

    if (existingTransportBloc != null) {
      this._transportBloc = existingTransportBloc;
      existingTransportBloc.attachedFormStateStream.listen((event) {
        formBloc.eventController.sink
            .add(transformAttachedContentToFormTypeCommand(event));
      });
    } else {
      this._transportBloc = this.initTransport();
      this._transportBloc.eventController.sink.add(ProducerInitEvent());
    }

    this
        ._transportBloc
        .attachedFormStateStream
        .listen((event) => this.updateState(event));

    this._attachedFormEventStream.listen((event) {
      this._transportBloc.eventController.add(event);
    });

    /**
     * Когда объект в форме готов, она кидает ObjectReadyFormInputState
     * при этом слушатели могут потребить полученный объект
     */
    formBloc.attachedInputStateStream
        .where((event) => event is ObjectReadyFormInputState<T>)
        .listen((event) {
      final objectTransferData = this.transformFormTypeToAttachedContent(event);
      this._transportBloc.eventController.sink.add(
          ProduceResourceEvent<AttachedFileContent<T>, C>(
              resource: objectTransferData, command: sendingCommand));
    });
  }
}
