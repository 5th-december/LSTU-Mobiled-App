import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/store/local/private_dialog_page_provider.dart';
import 'package:lk_client/widget/form/private_message_input_widget.dart';
import 'package:lk_client/widget/layout/private_chat_app_bar.dart';
import 'package:lk_client/widget/list/private_message_list.dart';

class PrivateDialogPage extends StatefulWidget {
  final DialogModel.Dialog dialog;
  final Person companion;

  PrivateDialogPage({Key key, this.companion, this.dialog}): super(key: key);

  @override
  _PrivateDialogPageState createState() => _PrivateDialogPageState();
}

class _PrivateDialogPageState extends State<PrivateDialogPage> {
  @override
  Widget build(BuildContext context) {
    return PrivateDialogPageProvider(
      child: Scaffold(
        appBar: PrivateChatAppBar(companion: widget.companion),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 75),
              child: PrivateMessageHistoryList(dialog: widget.dialog),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: PrivateMessageInputWidget(dialog: widget.dialog)
            ),
          ]
        ),
      )
    );
  }
}