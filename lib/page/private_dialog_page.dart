import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/private_message_form_bloc.dart';
import 'package:lk_client/bloc/attached/single_type_attachment_form_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/private_message_list_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/bloc/proxy/abstract_attached_form_transport_proxy_bloc.dart';
import 'package:lk_client/bloc/proxy/private_message_form_transport_proxy_bloc.dart';
import 'package:lk_client/bloc/proxy/private_message_list_proxy_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/service/api_consumer/file_transfer_service.dart';
import 'package:lk_client/service/api_consumer/messenger_query_service.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/attached_bloc_provider.dart';
import 'package:lk_client/store/global/loader_provider.dart';
import 'package:lk_client/store/global/mbc_bloc_provider.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'package:lk_client/store/local/private_dialog_page_provider.dart';
import 'package:lk_client/widget/form/attached_private_messaging_form.dart';
import 'package:lk_client/widget/layout/private_chat_app_bar.dart';
import 'package:lk_client/widget/list/private_message_list.dart';

class PrivateDialogPage extends StatefulWidget {
  final DialogModel.Dialog dialog;
  final Person companion;
  final Person person;

  PrivateDialogPage({Key key, this.person, this.dialog, this.companion})
      : super(key: key);

  @override
  _PrivateDialogPageState createState() => _PrivateDialogPageState();
}

class _PrivateDialogPageState extends State<PrivateDialogPage> {
  Future<PrivateMessageListProxyBloc> privateMessageListProxyBloc;

  FileTransferService fileTransferService;

  MessengerQueryService messengerQueryService;

  AttachedBlocProvider attachedBlocProvider;

  @override
  void dispose() {
    privateMessageListProxyBloc.then((bloc) => bloc.dispose());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ServiceProvider appServiceProvider =
        AppStateContainer.of(context).serviceProvider;

    if (this.privateMessageListProxyBloc == null) {
      final privateChatMessagesListLoadingBloc =
          PrivateChatMessagesListLoadingBloc(
              appServiceProvider.messengerQueryService);

      final privateMessageListBloc =
          PrivateMessageListBloc(privateChatMessagesListLoadingBloc);

      this.privateMessageListProxyBloc = PrivateMessageListProxyBloc.init(
          dialog: widget.dialog,
          person: widget.person,
          privateMessageListBloc: privateMessageListBloc,
          mbCChatUpdateBlocContainer:
              MbCBlocProvider.of(context).mbCChatUpdateBlocContainer(),
          mbCPrivateMessageBlocContainer:
              MbCBlocProvider.of(context).mbCPrivateMessageBlocContainer());
    }

    if (this.fileTransferService == null) {
      this.fileTransferService = appServiceProvider.fileTransferService;
    }

    if (this.messengerQueryService == null) {
      this.messengerQueryService = appServiceProvider.messengerQueryService;
    }

    if (attachedBlocProvider == null) {
      this.attachedBlocProvider =
          LoaderProvider.of(context).attachedBlocProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageFormObjectBuilder = PrivateMessageFormObjectBuilder();
    final formBloc =
        SingleTypeAttachementFormBloc<PrivateMessage>(messageFormObjectBuilder);
    return PrivateDialogPageProvider(
        child: Scaffold(
      appBar: PrivateChatAppBar(companion: widget.companion),
      body: Stack(children: [
        Container(
          padding: EdgeInsets.only(bottom: 75),
          child: PrivateMessageList(
              dialog: widget.dialog,
              person: widget.person,
              privateMessageListProxyBloc: this.privateMessageListProxyBloc),
        ),
        Align(
            alignment: Alignment.bottomLeft,
            child: AttachedMessageForm(
              controllerProvider: messageFormObjectBuilder,
              formBloc: formBloc,
              transportProxyBloc: PrivateMessageFormTransportProxyBloc(
                  messengerQueryService: this.messengerQueryService,
                  fileTransferService: this.fileTransferService,
                  formBloc: formBloc,
                  sendingCommand: SendNewPrivateMessage(dialog: widget.dialog),
                  attachmentBlocProvider: attachedBlocProvider),
            )),
      ]),
    ));
  }
}
