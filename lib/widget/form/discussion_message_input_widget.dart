import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/attached_discussion_form_bloc.dart';
import 'package:lk_client/bloc/attached/discussion_message_form_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/discipline/discipline.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/education/education.dart';
import 'package:lk_client/model/education/semester.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/util/attached_file_content.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/page/basic/fullscreen_error_page.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/service/app_config.dart';
import 'package:lk_client/service/file_local_manager.dart';
import 'package:lk_client/state/producing_state.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/widget/form/attached_form.dart';

class DiscussionMessageInputWidget extends StatefulWidget {
  final Education education;
  final Discipline discipline;
  final Semester semester;
  final Person person;

  DiscussionMessageInputWidget({
    Key key,
    @required this.discipline,
    @required this.education,
    @required this.person,
    @required this.semester
  });

  @override
  _DiscussionMessageInputWidget createState() => _DiscussionMessageInputWidget();
}

class _DiscussionMessageInputWidget extends State<DiscussionMessageInputWidget> {
  AttachedDiscussionFormBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._bloc == null) {
      AppState appState = AppStateContainer.of(context);
      MessengerQueryService messengerQueryService = appState.serviceProvider.messengerQueryService;
      AppConfig appConfig = appState.serviceProvider.appConfig;
      FileTransferService fileTransferService = appState.serviceProvider.fileTransferService;
      FileLocalManager fileLocalManager = appState.serviceProvider.fileLocalManager;
      DiscussionMessageFormBloc discussionMessageFormBloc = 
        DiscussionMessageFormBloc(messengerQueryService: messengerQueryService);
      DiscussionMessageSendDocumentTransferBloc discussionMessageSendDocumentTransferBloc = 
        DiscussionMessageSendDocumentTransferBloc(appConfig, fileLocalManager, fileTransferService);
      this._bloc = AttachedDiscussionFormBloc(
        discussionMessageFormBloc: discussionMessageFormBloc,
        discussionMessageSendDocumentTransferBloc: discussionMessageSendDocumentTransferBloc
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(ProducerInitEvent<AttachedFileContent<DiscussionMessage>>());

    return StreamBuilder(
      stream: this._bloc.attachedFormStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          final state = snapshot.data as ProducingState<DiscussionMessage>;

          return AttachedForm(
            hasInvalidations: state is ProducingInvalidState, 
            hasErrors: state is ProducingErrorState,
            onSendAction: ({@required String messageText, LocalFilesystemObject attachment, ExternalLink link}) {
              DiscussionMessage msg = DiscussionMessage(msg: messageText, externalLinks: <ExternalLink>[link]);
              AttachedFileContent<DiscussionMessage> content = AttachedFileContent<DiscussionMessage>(file: attachment, content: msg);
              this._bloc.eventController.sink.add(ProduceResourceEvent<AttachedFileContent<DiscussionMessage>, SendNewDiscussionMessage>(
                  resource: content,
                  command: SendNewDiscussionMessage(
                    discipline: widget.discipline,
                    semester: widget.semester,
                    education: widget.education,
                  )
              ));
            },
          );
        }

        return FullscreenErrorPage('Загружается');
      },
    );
  }
}