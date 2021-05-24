import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/attached_form_bloc.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/model/validatable.dart';
import 'package:lk_client/state/attached_form_state.dart';
import 'package:lk_client/widget/chunk/list_loading_bottom_indicator.dart';

class AttachedMessagingForm extends StatefulWidget {
  // TODO: Сохранение введенных данных при перестроении формы из вышележащего виджета

  // Флаг ожидания формы
  final bool isWaiting;

  // Инвалидация параметров формы, передается вышележащим виджетом при перестроении через StreamBuilder
  final bool hasInvalidations;
  final ValidationErrorBox errorBox;

  // Флаг наличия ошибок, не связанных с валидацией
  final bool hasErrors;
  // Текст ошибок
  final String errorText;

  // Функция отправки сообщения, параметры messageText, attachment, link
  final Function onSendAction;

  AttachedMessagingForm(
      {Key key,
      @required this.hasInvalidations,
      this.errorBox,
      @required this.isWaiting,
      @required this.hasErrors,
      @required this.onSendAction,
      this.errorText})
      : super(key: key);

  @override
  _AttachedMessagingFormState createState() => _AttachedMessagingFormState();
}

class _AttachedMessagingFormState extends State<AttachedMessagingForm> {
  AttachedFormBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._bloc == null) {
      this._bloc = AttachedFormBloc();

      // Инициализация блока добавления файлов
      this._bloc.eventController.add(InitAttachedInputEvent());
    }
  }

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
              ._bloc
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
    TextEditingController controller = TextEditingController();

    return StreamBuilder(
        stream: this._bloc.attachedInputStateStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
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
                        child: Row(children: () {
                          List<Widget> secondaryWidgetsRow = <Widget>[];
                          if (state is LinkAttachedState) {
                            secondaryWidgetsRow.add(this.getNotificationTile(
                                'Добавлена внешняя ссылка ${state.attachedLink.linkBaseUrl}',
                                false));
                          }
                          if (state is FileAttachedState) {
                            secondaryWidgetsRow.add(this.getNotificationTile(
                                'Добавлен файл ${state.fileAttachment.fileExtension}',
                                false));
                          }
                          if (widget.errorText != null) {
                            secondaryWidgetsRow.add(this
                                .getNotificationTile(widget.errorText, true));
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

                                if (!(state is LinkAttachedState)) {
                                  leadingRowWidgets.add(
                                      state is FileAttachedState
                                          ? this.getRemoveAttachmentButton()
                                          : this.getAddAttachmentButton());
                                  leadingRowWidgets.add(SizedBox(
                                    width: 5.0,
                                  ));
                                }

                                if (!(state is FileAttachedState)) {
                                  leadingRowWidgets.add(
                                      state is LinkAttachedState
                                          ? this.getRemoveLinkButton()
                                          : this.getAddLinkButton());
                                  leadingRowWidgets.add(SizedBox(
                                    width: 5.0,
                                  ));
                                }

                                leadingRowWidgets.add(Expanded(
                                  child: TextFormField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintText: 'Ваше сообщение',
                                      hintStyle: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400),
                                      border: InputBorder.none,
                                      errorText: () {
                                        // Показывает первую ошибку в форме
                                        if (widget.hasErrors &&
                                            widget.errorBox != null) {
                                          final errorList =
                                              widget.errorBox.getAll();
                                          if (errorList.length != 0) {
                                            return errorList[0].message;
                                          }
                                        }
                                        return null;
                                      }(),
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
                          child: ElevatedButton(
                              child: widget.isWaiting
                                  ? Icon(
                                      Icons.access_time_rounded,
                                      size: 35.0,
                                    )
                                  : Icon(Icons.send_rounded, size: 35.0),
                              onPressed: () {
                                if (widget.isWaiting) return;
                                /**
                                 * Отправка данных формы
                                 */
                                if (state is FileAttachedState) {
                                  widget.onSendAction(
                                      messageText: controller.text,
                                      attachment: state.fileAttachment);
                                } else if (state is LinkAttachedState) {
                                  widget.onSendAction(
                                      messageText: controller.text,
                                      link: state.attachedLink);
                                } else {
                                  widget.onSendAction(
                                      messageText: controller.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder())),
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
