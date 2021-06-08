import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/single_type_attachment_form_bloc.dart';
import 'package:lk_client/bloc/proxy/abstract_attached_form_transport_proxy_bloc.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/event/producing_event.dart';
import 'package:lk_client/model/discipline/discussion_message.dart';
import 'package:lk_client/model/discipline/work_answer_attachment.dart';
import 'package:lk_client/model/messenger/private_message.dart';
import 'package:lk_client/state/attached_form_state.dart';
import 'package:lk_client/state/producing_state.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';

class AttachedMessageForm extends StatefulWidget {
  final SingleTypeAttachementFormBloc formBloc;

  final MessagingFormControllerProvider controllerProvider;

  final AbstractAttachedFormTransportProxyBloc transportProxyBloc;

  AttachedMessageForm(
      {Key key,
      @required this.controllerProvider,
      @required this.formBloc,
      @required this.transportProxyBloc})
      : super(key: key);

  @override
  _AttachedMessageFormState createState() => _AttachedMessageFormState(
      formBloc: this.formBloc,
      controllerProvider: this.controllerProvider,
      transportProxyBloc: this.transportProxyBloc);
}

class _AttachedMessageFormState extends State<AttachedMessageForm> {
  /*
   * Блок сборки сообщения
   * Собирает объект своего состояния готовности из объекта, произведенного формой
   * и прикрепленных файлов и внешних ссылок
   */
  SingleTypeAttachementFormBloc formBloc;

  /*
   * Собирает объект формы из контроллеров ввода 
   */
  MessagingFormControllerProvider controllerProvider;

  AbstractAttachedFormTransportProxyBloc transportProxyBloc;

  _AttachedMessageFormState(
      {@required this.controllerProvider,
      @required this.formBloc,
      @required this.transportProxyBloc});

  Widget getAddAttachmentButton() {
    return IconButton(
      iconSize: 25.0,
      color: Colors.grey.shade500,
      icon: const Icon(Icons.attachment_rounded),
      onPressed: () async {
        // Получение добавляемого файла с FilePicker
        final files = await FilePicker.platform.pickFiles(allowMultiple: false);

        if (files != null) {
          this
              .formBloc
              .eventController
              .sink
              .add(AddFileAttachmentEvent(attachmentPath: files.paths[0]));
        } else {
          await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                // Диалог отмены добавления файла
                return AlertDialog(
                  title: Text('Добавление файла отменено'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('ОК'))
                  ],
                );
              });
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
            // Диалог удаления файла, возвращает флаг отмены файла
            return AlertDialog(
              title: Text('Отменить добавление файла?'),
              actions: <Widget>[
                TextButton(
                    child: Text('Отмена'),
                    onPressed: () => Navigator.of(context).pop(false)),
                TextButton(
                    child: Text('ОК'),
                    onPressed: () => Navigator.of(context).pop(true))
              ],
            );
          },
        );

        if (confirmation) {
          this.formBloc.eventController.sink.add(RemoveFileAttachmentEvent());
        }
      },
    );
  }

  Widget getAddLinkButton() {
    return IconButton(
        iconSize: 25.0,
        color: Colors.grey.shade500,
        icon: const Icon(Icons.open_in_browser_rounded),
        onPressed: () {});
  }

  Widget getRemoveLinkButton() {
    return IconButton(
        icon: const Icon(Icons.delete_outline_rounded),
        color: Colors.grey.shade500,
        iconSize: 25.0,
        onPressed: () {});
  }

  Widget getNotificationTile(String attachmentName, bool isWarning) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      decoration: BoxDecoration(
          color: isWarning ? Colors.red.shade700 : Colors.blue.shade700,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Text(
        attachmentName,
        style: TextStyle(fontSize: 14.0, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.formBloc.eventController.sink.add(InitAttachedFormInputEvent());
    return StreamBuilder(
        stream: this.formBloc.attachedInputStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            AttachedFormInputState state = snapshot.data;

            return Container(
                padding: EdgeInsets.only(bottom: 10.0),
                height: 100,
                child: Stack(
                  children: [
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Expanded(
                        child: Row(children: () {
                          List<Widget> secondaryWidgetsRow = <Widget>[];
                          if (state.attachedLink != null) {
                            secondaryWidgetsRow.add(this.getNotificationTile(
                                'Добавлена внешняя ссылка ${state.attachedLink.linkBaseUrl}',
                                false));
                          }
                          if (state.fileAttachment != null) {
                            secondaryWidgetsRow.add(this.getNotificationTile(
                                'Добавлен файл ${state.fileAttachment.fileExtension}',
                                false));
                          }
                          return [Row(children: secondaryWidgetsRow)];
                        }()),
                      ),
                    ),
                    Positioned(
                        top: 30.0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 70.0,
                          color: Colors.white,
                          child: Expanded(
                            child: Row(
                              children: () {
                                List<Widget> leadingRowWidgets = <Widget>[];

                                if (!(state.attachedLink != null)) {
                                  leadingRowWidgets.add(
                                      state.fileAttachment != null
                                          ? this.getRemoveAttachmentButton()
                                          : this.getAddAttachmentButton());
                                  leadingRowWidgets.add(SizedBox(
                                    width: 5.0,
                                  ));
                                }

                                if (!(state.fileAttachment != null)) {
                                  leadingRowWidgets.add(
                                      state.attachedLink != null
                                          ? this.getRemoveLinkButton()
                                          : this.getAddLinkButton());
                                  leadingRowWidgets.add(SizedBox(
                                    width: 5.0,
                                  ));
                                }

                                leadingRowWidgets.add(Expanded(
                                  child: TextFormField(
                                    controller: this
                                        .controllerProvider
                                        .messageTextEditingController,
                                    decoration: InputDecoration(
                                      hintText: 'Ваше сообщение',
                                      hintStyle: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ));

                                return leadingRowWidgets;
                              }(),
                            ),
                          ),
                        )),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0, bottom: 12.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              width: 70.0, height: 70.0),
                          child: StreamBuilder(
                              stream: this
                                  .transportProxyBloc
                                  .attachedFormStateStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data is ProducingLoadingState) {
                                    return ElevatedButton(
                                        child: Icon(Icons.access_time_rounded,
                                            size: 35.0),
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green.shade400,
                                            shape: CircleBorder()));
                                  } else if (snapshot.data
                                      is ProducingErrorState) {
                                    return ElevatedButton(
                                        child: Icon(Icons.error_outline_rounded,
                                            size: 35.0),
                                        onPressed: () => this
                                            .formBloc
                                            .eventController
                                            .sink
                                            .add(PrepareFormObjectEvent()),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red.shade400,
                                            shape: CircleBorder()));
                                  } else if (snapshot.data
                                      is ProducingReadyState) {
                                    this
                                        .formBloc
                                        .eventController
                                        .sink
                                        .add(InitAttachedFormInputEvent());

                                    this
                                        .transportProxyBloc
                                        .eventController
                                        .add(ProducerInitEvent());
                                  }

                                  return ElevatedButton(
                                      child:
                                          Icon(Icons.send_rounded, size: 35.0),
                                      onPressed: () => this
                                          .formBloc
                                          .eventController
                                          .sink
                                          .add(PrepareFormObjectEvent()),
                                      style: ElevatedButton.styleFrom(
                                          shape: CircleBorder()));
                                }

                                return ElevatedButton(
                                    child: Icon(Icons.send_rounded, size: 35.0),
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        shape: CircleBorder()));
                              }),
                        ),
                      ),
                    ),
                  ],
                ));
          }

          return ListLoadingBottomIndicator();
        });
  }
}

abstract class MessagingFormControllerProvider {
  final TextEditingController messageTextEditingController;
  MessagingFormControllerProvider(
      {@required this.messageTextEditingController});
}

abstract class WorkAnswerAttachmentFormControllerProvider {
  final TextEditingController responseNameTextEditionController;
  WorkAnswerAttachmentFormControllerProvider(
      {@required this.responseNameTextEditionController});
}

abstract class FormObjectBuilder<T> {
  T getFormObject();
  clearFormObject();
}

class PrivateMessageFormObjectBuilder extends MessagingFormControllerProvider
    implements FormObjectBuilder<PrivateMessage> {
  PrivateMessageFormObjectBuilder()
      : super(messageTextEditingController: TextEditingController());

  @override
  PrivateMessage getFormObject() {
    return PrivateMessage(messageText: this.messageTextEditingController.text);
  }

  @override
  clearFormObject() {
    this.messageTextEditingController.text = '';
  }
}

class DiscussionMessageFormObjectBuilder extends MessagingFormControllerProvider
    implements FormObjectBuilder<DiscussionMessage> {
  DiscussionMessageFormObjectBuilder()
      : super(messageTextEditingController: TextEditingController());

  @override
  DiscussionMessage getFormObject() {
    return DiscussionMessage(msg: messageTextEditingController.text);
  }

  @override
  clearFormObject() {
    this.messageTextEditingController.text = '';
  }
}

class WorkAnswerAttachmentFormObjectBuilder
    extends WorkAnswerAttachmentFormControllerProvider
    implements FormObjectBuilder<WorkAnswerAttachment> {
  WorkAnswerAttachmentFormObjectBuilder()
      : super(responseNameTextEditionController: TextEditingController());

  @override
  WorkAnswerAttachment getFormObject() {
    return WorkAnswerAttachment(
        name: this.responseNameTextEditionController.text);
  }

  @override
  clearFormObject() {
    this.responseNameTextEditionController.text = '';
  }
}
