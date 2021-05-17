import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/abstract_bloc.dart';
import 'package:lk_client/model/data_transfer/attachment.dart';
import 'package:lk_client/model/data_transfer/external_link.dart';
import 'package:lk_client/model/util/local_filesystem_object.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';

abstract class AttachedInputState {}

class NoAttachedDataState extends AttachedInputState {}

class FileAttachedState extends AttachedInputState {
  final LocalFilesystemObject fileAttachment;
  FileAttachedState({@required this.fileAttachment});
}

class LinkAttachedState extends AttachedInputState {
  final ExternalLink attachedLink;
  LinkAttachedState({@required this.attachedLink});
}

abstract class AttachedInputEvent {}

class InitAttachedInputEvent extends AttachedInputEvent {}

class AddFileAttachmentEvent extends AttachedInputEvent {
  final String attachmentPath;
  AddFileAttachmentEvent({@required this.attachmentPath});
}

class RemoveFileAttachmentEvent extends AttachedInputEvent {}

class AddExternalLinkEvent extends AttachedInputEvent {
  final String externalLinkText;
  final String extenalLinkContent;
  AddExternalLinkEvent({@required this.extenalLinkContent, @required this.externalLinkText});
}

class RemoveExternalLinkEvent extends AttachedInputEvent {}

class AttachedFormBloc extends AbstractBloc<AttachedInputState, AttachedInputEvent> {
  Stream<AttachedInputState> get attachedInputStateStream => 
    this.stateContoller.stream.where((event) => event is AttachedInputState);

  Stream<AttachedInputEvent> get _attachedInputEventStream =>
    this.eventController.stream.where((event) => event is AttachedInputEvent);

  AttachedFormBloc() {
    this._attachedInputEventStream.listen((event) {
      if(event is InitAttachedInputEvent && currentState == null) {
        // Тут можно подтягивать ранее введенные и неотправленные данные 
        this.updateState(NoAttachedDataState());
      }
      if(event is AddFileAttachmentEvent && currentState is NoAttachedDataState) { // Добавление файла
        LocalFilesystemObject addedAttachment = LocalFilesystemObject.fromFilePath(event.attachmentPath);
        this.updateState(FileAttachedState(fileAttachment: addedAttachment));
      } else if (event is AddExternalLinkEvent) { // Добавление внешней ссылки
        ExternalLink addedLink = 
          ExternalLink(linkContent: event.extenalLinkContent, linkText: event.externalLinkText);
        this.updateState(LinkAttachedState(attachedLink: addedLink));
      } else if ((event is RemoveExternalLinkEvent && currentState is LinkAttachedState) || 
        (event is RemoveFileAttachmentEvent && currentState is FileAttachedState)) { // Удаление всех вложений при условии их наличия
        this.updateState(NoAttachedDataState());
      }
    });
  }
}

class AttachedForm extends StatefulWidget
{
  final bool hasInvalidations;
  final String messageValidationErrorText;
  final String attachmentValidationErrorText;
  final String linksValidationErrorText;
  final bool hasErrors;
  final String errorText;
  final Function onSendAction;

  AttachedForm({
    Key key,
    @required this.hasInvalidations,
    this.messageValidationErrorText,
    this.attachmentValidationErrorText,
    this.linksValidationErrorText,
    @required this.hasErrors,
    @required this.onSendAction,
    this.errorText
  }): super(key: key);

  @override
  _AttachedFormState createState() => _AttachedFormState();
}

class _AttachedFormState extends State<AttachedForm>
{
  AttachedFormBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this._bloc == null) {
      this._bloc = AttachedFormBloc();
    }
  }

  Widget getAddAttachmentButton() {
    return IconButton(
      iconSize: 25.0,
      color: Colors.grey.shade500,
      icon: const Icon(Icons.attachment_rounded),
      onPressed: () async {
        final files = await FilePicker.platform.pickFiles(allowMultiple: false);
        if(files != null) {
          this._bloc.eventController.sink.add(AddFileAttachmentEvent(attachmentPath: files.paths[0]));
        } else {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Добавление файла отменено'),
                actions: <Widget>[
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('ОК'))
                ],
              );
            }
          );
        }
      },
    );
  }

  Widget getRemoveAttachmentButton() {
    return IconButton(
      iconSize: 25.0,
      color: Colors.grey.shade500,
      icon: const Icon(Icons.highlight_off_rounded),
      onPressed: () async {
        bool confirmation = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Отменить добавление файла?'),
              actions: <Widget>[
                TextButton(child: Text('Отмена'), onPressed: () => Navigator.of(context).pop(false)),
                TextButton(child: Text('ОК'), onPressed: () => Navigator.of(context).pop(true))
              ],
            );
          },
        );

        if(confirmation) {
          this._bloc.eventController.sink.add(RemoveFileAttachmentEvent());
        }
      },
    );
  }

  Widget getAddLinkButton() {
    return IconButton(
      iconSize: 25.0, 
      color: Colors.grey.shade500,
      icon: const Icon(Icons.open_in_browser_rounded),
      onPressed: () {}
    );
  }

  Widget getRemoveLinkButton() {
    return IconButton(
      icon: const Icon(Icons.delete_outline_rounded),
      color: Colors.grey.shade500,
      iconSize: 25.0,
      onPressed: () {}
    );
  }

  Widget getNotificationTile(String attachmentName, bool isWarning) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      decoration: BoxDecoration(color: isWarning ? Colors.red.shade700 : Colors.blue.shade700, 
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Text(attachmentName, style: TextStyle(fontSize: 14.0, color: Colors.white),),
    );
  }

  @override
  Widget build(BuildContext context) {
    this._bloc.eventController.add(InitAttachedInputEvent());

    TextEditingController controller = TextEditingController();

    return StreamBuilder(
      stream: this._bloc.attachedInputStateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          AttachedInputState state = snapshot.data;

          return Container(
            padding: EdgeInsets.only(bottom: 10.0),
            height: 100,
            child: Stack(
              children: [
                Container(
                  height: 30.0,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Expanded(
                    child: Row(
                      children: () {
                        List<Widget> secondaryWidgetsRow = <Widget>[];
                        if(state is LinkAttachedState) {
                          secondaryWidgetsRow.add(this.getNotificationTile('Добавлена внешняя ссылка', true));
                        }
                        if(state is FileAttachedState) {
                          secondaryWidgetsRow.add(this.getNotificationTile('Добавлен файл', true));
                        }
                        if(widget.errorText != null) {
                          secondaryWidgetsRow.add(this.getNotificationTile(widget.errorText, true));
                        }
                        return [
                          Row(children: secondaryWidgetsRow)
                        ];
                      }()
                    ),
                  ),
                ),
                Positioned(
                  top: 30.0, bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: 70.0,
                    color: Colors.white,
                    child: Expanded(
                      child: Row(
                        children: () {
                          List<Widget> leadingRowWidgets = <Widget>[];

                          if(!(state is LinkAttachedState)) {
                            leadingRowWidgets.add(state is FileAttachedState ? 
                              this.getRemoveAttachmentButton() : this.getAddAttachmentButton());
                            leadingRowWidgets.add(SizedBox(width: 5.0,));
                          }

                          if(!(state is FileAttachedState)) {
                            leadingRowWidgets.add(state is LinkAttachedState ? this.getRemoveLinkButton(): this.getAddLinkButton());
                            leadingRowWidgets.add(SizedBox(width: 5.0,));
                          }

                          leadingRowWidgets.add(
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: 'Ваше сообщение',
                                  hintStyle: TextStyle(color: Colors.black45, fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                  errorText: (widget.messageValidationErrorText != null && widget.messageValidationErrorText.length != 0) ? widget.messageValidationErrorText[0] : null
                                ),
                              ),
                            ),
                          );

                          return leadingRowWidgets;

                        }(),
                      ),
                    ),
                  ) 
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0, bottom: 12.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 70.0, height: 70.0),
                      child: ElevatedButton(
                        child: Icon(Icons.send_rounded, size: 35.0),
                        onPressed: () {
                          if(state is FileAttachedState) {
                            widget.onSendAction(messageText: controller.text, attachment: state.fileAttachment);
                          } else if (state is LinkAttachedState) {
                            widget.onSendAction(messageText: controller.text, link: state.attachedLink);
                          } else {
                            widget.onSendAction(messageText: controller.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder()
                        )
                      ),
                    ),
                  ),
                ),                    
              ],
            )
          );
        }

        return ListLoadingBottomIndicator();
      }
    );
  }
}
