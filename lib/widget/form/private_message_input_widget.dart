import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/attached_private_message_form_bloc.dart';
import 'package:lk_client/command/produce_command.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/util/attached_file_content.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/state/producing_state.dart';
import 'package:lk_client/store/local/private_dialog_page_provider.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';
import 'package:lk_client/widget/form/attached_form.dart';

class PrivateMessageInputWidget extends StatefulWidget {
  final DialogModel.Dialog dialog;

  PrivateMessageInputWidget({Key key, this.dialog}): super(key: key);

  @override
  _PrivateMessageInputWidgetState createState() => _PrivateMessageInputWidgetState();
}

class _PrivateMessageInputWidgetState extends State<PrivateMessageInputWidget> {
  AttachedPrivateMessageFormBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._bloc == null) {
      this._bloc = PrivateDialogPageProvider.of(context).attachedPrivateMessageFormBloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(ProducerInitEvent<AttachedFileContent<PrivateMessage>>());

    return StreamBuilder(
      stream: this._bloc.attachedFormStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          final state = snapshot.data as ProducingState<PrivateMessage>;

          return AttachedForm(
            hasInvalidations: state is ProducingInvalidState, 
            hasErrors: state is ProducingErrorState,
            onSendAction: ({@required String messageText, LocalFilesystemObject attachment, ExternalLink link}) {

              PrivateMessage msg = PrivateMessage(
                messageText: messageText, 
                links: <ExternalLink>[link]
              );

              AttachedFileContent<PrivateMessage> privateMessage = AttachedFileContent<PrivateMessage>(
                content: msg, 
                file: attachment
              );

              this._bloc.eventController.sink.add(
                ProduceResourceEvent<AttachedFileContent<PrivateMessage>, SendNewPrivateMessage>(
                  command: SendNewPrivateMessage(dialog: widget.dialog), resource: privateMessage
                )
              );
            },
          );
        }

        return ListLoadingBottomIndicator();
      }
    );
  }
}