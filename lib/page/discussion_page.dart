import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/single_type_attachment_form_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/discussion_list_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/bloc/proxy/discussion_message_form_transport_proxy_bloc.dart';
import 'package:lk_client/bloc/proxy/discussion_message_list_proxy_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/attached_bloc_provider.dart';
import 'package:lk_client/store/global/loader_provider.dart';
import 'package:lk_client/store/global/mbc_bloc_provider.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'package:lk_client/widget/form/attached_private_messaging_form.dart';
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

  FileTransferService fileTransferService;

  MessengerQueryService messengerQueryService;

  AttachedBlocProvider attachedBlocProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ServiceProvider appServiceProvider =
        AppStateContainer.of(context).serviceProvider;

    if (this.discussionMessageListProxyBloc == null) {
      final discussionListLoadingBloc =
          DiscussionLoadingBloc(appServiceProvider.messengerQueryService);
      final discussionListBloc = DiscussionListBloc(discussionListLoadingBloc);

      this.discussionMessageListProxyBloc = DiscussionMessageListProxyBloc.init(
          discussionListBloc: discussionListBloc,
          mbCDiscussionMessageBlocContainer:
              MbCBlocProvider.of(context).mbCDiscussionMessageBlocContainer(),
          mbCDiscussionUpdateBlocContainer:
              MbCBlocProvider.of(context).mbCDiscussionUpdateBlocContainer());
    }

    if (this.fileTransferService == null) {
      this.fileTransferService = appServiceProvider.fileTransferService;
    }

    if (this.messengerQueryService == null) {
      this.messengerQueryService = appServiceProvider.messengerQueryService;
    }

    if (this.attachedBlocProvider == null) {
      this.attachedBlocProvider =
          LoaderProvider.of(context).attachedBlocProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formObjectBuilder = DiscussionMessageFormObjectBuilder();
    final formBloc =
        SingleTypeAttachementFormBloc<DiscussionMessage>(formObjectBuilder);
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
            child: AttachedMessageForm(
              formBloc: formBloc,
              controllerProvider: formObjectBuilder,
              transportProxyBloc: DiscussionMessageFormTransportProxyBloc(
                  messengerQueryService: this.messengerQueryService,
                  fileTransferService: this.fileTransferService,
                  attachmentBlocProvider: this.attachedBlocProvider,
                  sendingCommand: SendNewDiscussionMessage(
                      discipline: widget.discipline,
                      education: widget.education,
                      semester: widget.semester),
                  formBloc: formBloc),
            ),
          )
        ],
      ),
    );
  }
}
