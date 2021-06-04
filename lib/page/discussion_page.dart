import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/infinite_scrollers/discussion_list_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/bloc/proxy/discussion_message_list_proxy_bloc.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/mbc_bloc_provider.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'package:lk_client/widget/form/discussion_message_input_widget.dart';
import 'package:lk_client/widget/list/discussion_message_list.dart';

class DiscussionPage extends StatefulWidget {
  final Education education;
  final Semester semester;
  final Discipline discipline;
  final Person person;

  DiscussionPage(
      {Key key,
      @required this.person,
      @required this.discipline,
      @required this.education,
      @required this.semester});

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  Future<DiscussionMessageListProxyBloc> discussionMessageListProxyBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this.discussionMessageListProxyBloc == null) {
      ServiceProvider serviceProvider =
          AppStateContainer.of(context).serviceProvider;
      final discussionListLoadingBloc =
          DiscussionLoadingBloc(serviceProvider.messengerQueryService);
      final discussionListBloc = DiscussionListBloc(discussionListLoadingBloc);

      this.discussionMessageListProxyBloc = DiscussionMessageListProxyBloc.init(
          discussionListBloc: discussionListBloc,
          mbCDiscussionMessageBlocContainer:
              MbCBlocProvider.of(context).mbCDiscussionMessageBlocContainer());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Обсуждение'),
      ),
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 75),
              child: DiscussionMessageList(
                discipline: widget.discipline,
                semester: widget.semester,
                education: widget.education,
                loggedPerson: widget.person,
                discussionMessageListProxyBloc:
                    this.discussionMessageListProxyBloc,
              )),
          Align(
            alignment: Alignment.bottomLeft,
            child: DiscussionMessageInputWidget(
                discipline: widget.discipline,
                semester: widget.semester,
                education: widget.education,
                person: widget.person),
          )
        ],
      ),
    );
  }
}
