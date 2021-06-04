import 'package:lk_client/bloc/message_broker_consumers/mbc_private_message_consumer_bloc.dart';
import 'package:lk_client/command/mbc_command.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/messenger/dialog.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/api_consumer/util_query_service.dart';
import 'package:lk_client/service/config/amqp_config.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class MbCPrivateMessageBlocContainer {
  AmqpService _amqpService;
  AmqpConfig _amqpConfig;

  Map<String, MbCPrivateMessageConsumerBloc> _storage;

  MbCPrivateMessageBlocContainer._(
      Map<String, MbCPrivateMessageConsumerBloc> watchingBlocs,
      AmqpConfig amqpConfig,
      AmqpService amqpService) {
    this._storage = watchingBlocs;
    this._amqpConfig = amqpConfig;
    this._amqpService = amqpService;
  }

  static Future<MbCPrivateMessageBlocContainer> init(
      UtilQueryService queryService,
      AmqpConfig amqpConfig,
      AmqpService amqpService) async {
    final dialogList = await queryService.getDialogIdentifiersFullList();
    final dialogIndetifiersList = dialogList.payload;

    final storageData = <String, MbCPrivateMessageConsumerBloc>{};
    for (Dialog dialogIdentifier in dialogIndetifiersList) {
      MbCPrivateMessageConsumerBloc bloc =
          await _initBloc(dialogIdentifier, amqpService, amqpConfig);
      storageData[dialogIdentifier.id] = bloc;
    }
    return MbCPrivateMessageBlocContainer._(
        storageData, amqpConfig, amqpService);
  }

  Future<MbCPrivateMessageConsumerBloc> getBloc(Dialog dialog) async {
    if (this._storage.containsKey(dialog.id)) {
      return this._storage[dialog.id];
    }

    MbCPrivateMessageConsumerBloc createdBloc =
        await _initBloc(dialog, this._amqpService, this._amqpConfig);
    this._storage[dialog.id] = createdBloc;
    return createdBloc;
  }

  static Future<MbCPrivateMessageConsumerBloc> _initBloc(
      Dialog dialog, AmqpService amqpService, AmqpConfig amqpConfig) async {
    final bloc = MbCPrivateMessageConsumerBloc(
        amqpConfig: amqpConfig, amqpService: amqpService);
    bloc.eventController.sink.add(StartNotificationConsumeEvent(
        command: MbCStartConsumeDialogMessages(dialog: dialog)));
    await for (var state in bloc.privateMessageConsumingStateStream) {
      if (state is NotificationReadyState<List<PrivateMessage>>) {
        return bloc;
      }
    }
  }
}
