import 'package:lk_client/bloc/message_broker_consumers/mbc_dialog_list_consumer_bloc.dart';
import 'package:lk_client/command/mbc_command.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/api_consumer/util_query_service.dart';
import 'package:lk_client/service/config/amqp_config.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class MbCDialogListBlocContainer {
  MbCDialogListConsumerBloc _bloc;

  MbCDialogListBlocContainer._(MbCDialogListConsumerBloc watchingBloc) {
    this._bloc = watchingBloc;
  }

  static Future<MbCDialogListBlocContainer> init(UtilQueryService queryService,
      AmqpConfig amqpConfig, AmqpService amqpService) async {
    final personIdentifier = await queryService.getCurrentPersonIdentifier();

    MbCDialogListConsumerBloc bloc =
        await _initBloc(personIdentifier, amqpService, amqpConfig);

    return MbCDialogListBlocContainer._(bloc);
  }

  MbCDialogListConsumerBloc getBloc() {
    return this._bloc;
  }

  static Future<MbCDialogListConsumerBloc> _initBloc(
      Person person, AmqpService amqpService, AmqpConfig amqpConfig) async {
    final bloc = MbCDialogListConsumerBloc(
        amqpConfig: amqpConfig, amqpService: amqpService);
    bloc.eventController.sink.add(StartNotificationConsumeEvent(
        command: MbCStartConsumeDialogListUpdates(receiver: person)));
    await for (var state in bloc.dialogListConsumingStateStream) {
      if (state is NotificationReadyState<List<Dialog>>) {
        return bloc;
      }
    }
  }
}
