import 'package:lk_client/bloc/message_broker_consumers/mbc_discussion_update_consumer_bloc.dart';
import 'package:lk_client/command/mbc_command.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/education/group.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/api_consumer/util_query_service.dart';
import 'package:lk_client/service/config/amqp_config.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class MbCDiscussionUpdateBlocContainer {
  MbCDiscussionUpdateConsumerBloc _bloc;

  MbCDiscussionUpdateBlocContainer._(
      MbCDiscussionUpdateConsumerBloc watchingBloc) {
    this._bloc = watchingBloc;
  }

  static Future<MbCDiscussionUpdateBlocContainer> init(
      UtilQueryService queryService,
      AmqpConfig amqpConfig,
      AmqpService amqpService) async {
    final groupsList = await queryService.getGroupsFullList();
    final groupsListIdentifiers = groupsList.payload;

    MbCDiscussionUpdateConsumerBloc bloc =
        await _initBloc(groupsListIdentifiers, amqpService, amqpConfig);

    return MbCDiscussionUpdateBlocContainer._(bloc);
  }

  MbCDiscussionUpdateConsumerBloc getBloc() {
    return this._bloc;
  }

  static Future<MbCDiscussionUpdateConsumerBloc> _initBloc(List<Group> groups,
      AmqpService amqpService, AmqpConfig amqpConfig) async {
    final bloc = MbCDiscussionUpdateConsumerBloc(
        amqpConfig: amqpConfig, amqpService: amqpService);
    bloc.eventController.sink.add(StartNotificationConsumeEvent(
        command: MbCStartConsumeDiscussionUpdates(groups: groups)));
    await for (var state in bloc.discissionUpdateNotificationStateStream) {
      if (state is NotificationReadyState<List<DiscussionMessage>>) {
        return bloc;
      }
    }
  }
}
