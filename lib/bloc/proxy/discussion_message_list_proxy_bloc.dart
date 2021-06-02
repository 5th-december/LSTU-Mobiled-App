import 'package:flutter/foundation.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/bloc/amqp_consumers/mbc_discussion_message_consumer_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/discussion_list_bloc.dart';
import 'package:lk_client/command/consume_command.dart';
import 'package:lk_client/event/endless_scrolling_event.dart';

class StartNotifyOnDiscussion {}

class DiscussionMessageListProxyBloc extends AbstractBloc<dynamic, dynamic> {
  final DiscussionListBloc listBloc;

  final MbCDiscussionMessageConsumerBloc mbcConsumerBloc;

  Stream<dynamic> get discussionMessageListStateStream =>
      this.stateContoller.stream;

  Stream<dynamic> get _discussionMessageListInitEventStream =>
      this.eventController.stream.where((event) =>
          event is EndlessScrollingLoadEvent<StartNotifyOnDiscussion>);

  Stream<dynamic> get _discussionMessageLoadEventStream =>
      this.eventController.stream.where((event) => event
          is EndlessScrollingLoadEvent<LoadDisciplineDiscussionListCommand>);

  DiscussionMessageListProxyBloc(
      {@required this.listBloc, @required this.mbcConsumerBloc}) {
    this._discussionMessageListInitEventStream.listen((event) {
      // должен быть уже инициализированным
    });

    this._discussionMessageLoadEventStream.listen((event) {});
  }
}
