import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/abstract_attached_form_bloc.dart';
import 'package:lk_client/bloc/attached_private_message_form_bloc.dart';
import 'package:lk_client/bloc/file_transfer_bloc.dart';
import 'package:lk_client/bloc/private_message_form_bloc.dart';
import 'package:lk_client/command/produce_command/private_message_produce_command.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/messenger/dialog.dart' as DialogModel;
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/store/global/app_state_container.dart';
import 'package:lk_client/store/global/service_provider.dart';

class AttachedMessageInputWidget extends StatefulWidget {
  final DialogModel.Dialog dialog;

  AttachedMessageInputWidget({Key key, this.dialog}): super(key: key);

  @override
  _AttachedMessageInputWidgetState createState() => _AttachedMessageInputWidgetState();
}

class _AttachedMessageInputWidgetState extends State<AttachedMessageInputWidget> {
  AttachedPrivateMessageFormBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._bloc == null) {
      ServiceProvider appServiceProvider = AppStateContainer.of(context).serviceProvider;

      PrivateMessageSendDocumentTransferBloc transferBloc = 
        PrivateMessageSendDocumentTransferBloc(appServiceProvider.appConfig, appServiceProvider.fileLocalManager, appServiceProvider.fileTransferService);
      PrivateMessageFormBloc messengerBloc = PrivateMessageFormBloc(messengerQueryService: appServiceProvider.messengerQueryService);

      this._bloc = AttachedPrivateMessageFormBloc(
        privateMessageDocumentTransferBloc: transferBloc, privateMessageFormBloc: messengerBloc);
    }
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.sink.add(ProducerInitEvent<AttachedFileContent<PrivateMessage>>());

    TextEditingController controller = TextEditingController();
    return StreamBuilder(
      stream: this._bloc.attachedFormStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String attachmentPath = '';


        return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          height: 70,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [ 
              Row(
                children: [
                  IconButton(
                    iconSize: 30.0,
                    color: Colors.grey.shade700,
                    icon: const Icon(Icons.attachment_outlined), 
                    onPressed: () async {
                      attachmentPath = (await FilePicker.platform.pickFiles(allowMultiple: false)).paths[0];
                    },
                  ),
                  SizedBox(width: 7.0,),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Ваше сообщение',
                        hintStyle: TextStyle(color: Colors.black45, fontWeight: FontWeight.w400),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  Ink(
                    decoration: ShapeDecoration(
                      color: Colors.blue.shade600,
                      shape: CircleBorder()
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send_rounded, size: 38.0,),
                      color: Colors.white,
                      onPressed: () {
                        PrivateMessage message = PrivateMessage(messageText: controller.text);

                        LocalFilesystemObject file;
                        if(attachmentPath != '') {
                          file = LocalFilesystemObject.fromBasePath(attachmentPath);
                        }

                        AttachedFileContent<PrivateMessage> content = AttachedFileContent<PrivateMessage>(
                          content: message, file: file ?? null
                        );

                        SendNewPrivateMessage command = SendNewPrivateMessage(dialog: widget.dialog);
                        this._bloc.eventController.sink.add(
                          ProduceResourceEvent<AttachedFileContent<PrivateMessage>, SendNewPrivateMessage>(command: command, resource: content)
                        );
                      },
                    )
                  )
                ],
              )
            ]
          )
        );
      }
    );
  }
}