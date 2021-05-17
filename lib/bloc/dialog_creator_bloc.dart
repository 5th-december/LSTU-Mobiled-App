import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/state/producing_state.dart';

class StartNewDialog {
  final Person companion;
  StartNewDialog({@required this.companion});
}

class DialogCreatorBloc extends AbstractBloc<ProducingState<void>, ProducingEvent<void>>
{
  Stream<ProducingState> get dialogCreatorStateStream => this.stateContoller.stream.where((event) => event is ProducingState<void>);

  Stream<ProducingEvent> get _dialogCreatorProduceEventStream => this.eventController.stream.where((event) => event is ProduceResourceEvent<void, StartNewDialog>);

  Stream<ProducingEvent> get _dialogCreatorInitStream => this.eventController.stream.where((event) => event is ProducerInitEvent<void>);

  DialogCreatorBloc({@required MessengerQueryService messengerQueryService}) {
    this.updateState(ProducingInitState<void>());

    this._dialogCreatorInitStream.listen((event) {
      if(!(currentState is ProducingLoadingState<void>)) {
        this.updateState(ProducingInitState<void>());
      }
    });

    this._dialogCreatorProduceEventStream.listen((event) async {
      final _event = event as ProduceResourceEvent<void, StartNewDialog>;
      this.updateState(ProducingLoadingState<void>());
      try {
        DialogModel.Dialog createdDialog = await messengerQueryService.createNewDialog(_event.command.companion.id);
        this.updateState(ProducingReadyState<void, DialogModel.Dialog>(response: createdDialog));
      } on Exception catch(e) {
        this.updateState(ProducingErrorState<DialogModel.Dialog>(e));
      }
    });
  }
}