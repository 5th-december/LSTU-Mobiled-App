import 'package:lk_client/bloc/message_broker_consumers/mbc_discussion_message_consumer_bloc.dart';
import 'package:lk_client/command/mbc_command.dart';
import 'package:lk_client/event/notification_consume_event.dart';
import 'package:lk_client/model/education/group.dart';
import 'package:lk_client/model/mb_objects/mb_discussion_message.dart';
import 'package:lk_client/service/amqp_service.dart';
import 'package:lk_client/service/api_consumer/util_query_service.dart';
import 'package:lk_client/service/config/amqp_config.dart';
import 'package:lk_client/state/notification_consume_state.dart';

class MbCDiscussionMessageBlocContainer {
  MbCDiscussionMessageConsumerBloc _bloc;

  MbCDiscussionMessageBlocContainer._(
      MbCDiscussionMessageConsumerBloc watchingBloc) {
    this._bloc = watchingBloc;
  }

  static Future<MbCDiscussionMessageBlocContainer> init(
      UtilQueryService queryService,
      AmqpConfig amqpConfig,
      AmqpService amqpService) async {
    final groupsList = await queryService.getGroupsFullList();
    final groupsListIdentifiers = groupsList.payload;

    MbCDiscussionMessageConsumerBloc bloc =
        await _initBloc(groupsListIdentifiers, amqpService, amqpConfig);

    return MbCDiscussionMessageBlocContainer._(bloc);
  }

  MbCDiscussionMessageConsumerBloc getBloc() {
    return this._bloc;
  }

  static Future<MbCDiscussionMessageConsumerBloc> _initBloc(List<Group> groups,
      AmqpService amqpService, AmqpConfig amqpConfig) async {
    final bloc = MbCDiscussionMessageConsumerBloc(
        amqpConfig: amqpConfig, amqpService: amqpService);
    bloc.eventController.sink.add(StartNotificationConsumeEvent(
        command: MbCStartConsumeDiscussionMessages(groups: groups)));
    await for (var state in bloc.discussionMessageConsumingStateStream) {
      if (state is NotificationReadyState<List<DiscussionUpdate>>) {
        return bloc;
      }
    }
  }
}
