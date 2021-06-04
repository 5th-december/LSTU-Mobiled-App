import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/attached_private_message_form_bloc.dart';
import 'package:lk_client/bloc/attached/file_transfer_bloc.dart';
import 'package:lk_client/bloc/attached/private_message_form_bloc.dart';
import 'package:lk_client/bloc/infinite_scrollers/private_message_list_bloc.dart';
import 'package:lk_client/bloc/loader/loader_bloc.dart';
import 'package:lk_client/bloc/proxy/private_message_list_proxy_bloc.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/mbc_bloc_provider.dart';
import 'package:lk_client/store/global/service_provider.dart';
import 'package:lk_client/store/local/private_dialog_page_provider.dart';
import 'package:lk_client/widget/form/private_message_input_widget.dart';
import 'package:lk_client/widget/layout/private_chat_app_bar.dart';
import 'package:lk_client/widget/list/private_message_list.dart';

class PrivateDialogPage extends StatefulWidget {
  final DialogModel.Dialog dialog;
  final Person companion;

  PrivateDialogPage({Key key, this.companion, this.dialog}) : super(key: key);

  @override
  _PrivateDialogPageState createState() => _PrivateDialogPageState();
}

class _PrivateDialogPageState extends State<PrivateDialogPage> {
  Future<PrivateMessageListProxyBloc> privateMessageListProxyBloc;

  AttachedPrivateMessageFormBloc attachedPrivateMessageFormBloc;

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
          companion: widget.companion,
          privateMessageListBloc: privateMessageListBloc,
          mbCChatUpdateBlocContainer:
              MbCBlocProvider.of(context).mbCChatUpdateBlocContainer(),
          mbCPrivateMessageBlocContainer:
              MbCBlocProvider.of(context).mbCPrivateMessageBlocContainer());
    }

    if (this.attachedPrivateMessageFormBloc == null) {
      final privateMessageSendDocumentTransferBloc =
          PrivateMessageSendDocumentTransferBloc(
              fileTransferService: appServiceProvider.fileTransferService);

      final privateMessageFormBloc = PrivateMessageFormBloc(
          messengerQueryService: appServiceProvider.messengerQueryService);

      this.attachedPrivateMessageFormBloc = AttachedPrivateMessageFormBloc(
          privateMessageDocumentTransferBloc:
              privateMessageSendDocumentTransferBloc,
          privateMessageFormBloc: privateMessageFormBloc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrivateDialogPageProvider(
        child: Scaffold(
      appBar: PrivateChatAppBar(companion: widget.companion),
      body: Stack(children: [
        Container(
          padding: EdgeInsets.only(bottom: 75),
          child: PrivateMessageList(
              dialog: widget.dialog,
              person: widget.companion,
              privateMessageListProxyBloc: this.privateMessageListProxyBloc),
        ),
        Align(
            alignment: Alignment.bottomLeft,
            child: PrivateMessageInputWidget(dialog: widget.dialog)),
      ]),
    ));
  }
}
