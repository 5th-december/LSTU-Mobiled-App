import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/single_type_attachment_form_bloc.dart';
import 'package:lk_client/bloc/proxy/abstract_attached_form_transport_proxy_bloc.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/state/attached_form_state.dart';
import 'package:lk_client/widget/chunk/form/semitransparent_text_form_field.dart';
import 'package:lk_client/widget/form/attached_private_messaging_form.dart';

class StudentTaskResponseForm extends StatefulWidget {
  final SingleTypeAttachementFormBloc formBloc;
  final WorkAnswerAttachmentFormControllerProvider controllerProvider;
  final AbstractAttachedFormTransportProxyBloc transportProxyBloc;

  StudentTaskResponseForm(
      {Key key,
      @required this.formBloc,
      @required this.controllerProvider,
      @required this.transportProxyBloc})
      : super(key: key);

  @override
  State<StudentTaskResponseForm> createState() =>
      _StatefulTaskResponseFormState(
          formBloc: this.formBloc,
          controllerProvider: this.controllerProvider,
          transportProxyBloc: this.transportProxyBloc);
}

class _StatefulTaskResponseFormState extends State<StudentTaskResponseForm> {
  final SingleTypeAttachementFormBloc formBloc;

  final WorkAnswerAttachmentFormControllerProvider controllerProvider;

  final AbstractAttachedFormTransportProxyBloc transportProxyBloc;

  _StatefulTaskResponseFormState(
      {@required this.formBloc,
      @required this.controllerProvider,
      @required this.transportProxyBloc}) {
    this.formBloc.eventController.sink.add(InitAttachedFormInputEvent());
  }

  Widget getAttachmentTypeSelection() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final files =
                      await FilePicker.platform.pickFiles(allowMultiple: false);

                  if (files != null) {
                    this.formBloc.eventController.sink.add(
                        AddFileAttachmentEvent(attachmentPath: files.paths[0]));
                  }
                },
                child: Icon(
                  Icons.description_rounded,
                  size: 36.0,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(165, 153, 255, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16.0))),
            SizedBox(
              height: 12.0,
            ),
            Text('Документ',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(165, 153, 255, 1.0)))
          ],
        ),
        Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    this._showLinkAttachmentForm = true;
                  });
                },
                child: Icon(
                  Icons.public_rounded,
                  size: 36.0,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(165, 153, 255, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16.0))),
            SizedBox(
              height: 12.0,
            ),
            Text('Внешняя ссылка',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(165, 153, 255, 1.0)))
          ],
        )
      ],
    );
  }

  bool _showLinkAttachmentForm = false;

  Widget getExternalLinkAttachmentForm() {
    GlobalKey key = GlobalKey();
    TextEditingController externalLinkTextController = TextEditingController();

    return Form(
      key: key,
      child: Column(
        children: [
          SemitransparentTextFormField(
              controller: externalLinkTextController,
              hintText: 'Ссылка на внешний ресурс',
              icon: Icons.public_rounded),
          SizedBox(
            height: 12.0,
          ),
          ElevatedButton(
              onPressed: () {
                this.formBloc.eventController.sink.add(AddExternalLinkEvent(
                    extenalLinkContent: externalLinkTextController.text,
                    externalLinkText: externalLinkTextController.text));

                setState(() {
                  this._showLinkAttachmentForm = false;
                });
              },
              child: Text('Добавить'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey formKey = GlobalKey();
    return Form(
        key: formKey,
        child: Column(
          children: [
            SemitransparentTextFormField(
              controller:
                  this.controllerProvider.responseNameTextEditionController,
              hintText: 'Название ответа',
              icon: Icons.segment,
            ),
            SizedBox(
              height: 30.0,
            ),
            StreamBuilder(
                stream: this.formBloc.attachedInputStateStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final state = snapshot.data as AttachedFormInputState;

                    if (state.attachedLink == null &&
                        state.fileAttachment == null) {
                      if (this._showLinkAttachmentForm) {
                        return this.getExternalLinkAttachmentForm();
                      } else {
                        return getAttachmentTypeSelection();
                      }
                    }

                    return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 35.0, vertical: 15.0),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(137, 64, 253, 1.0),
                                border: Border.all(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0))),
                            child: Row(
                              children: [
                                () {
                                  if (state.fileAttachment != null) {
                                    return Icon(
                                      Icons.description_rounded,
                                      size: 36.0,
                                      color: Colors.white,
                                    );
                                  } else if (state.attachedLink != null) {
                                    return Icon(
                                      Icons.public_rounded,
                                      size: 36.0,
                                      color: Colors.white,
                                    );
                                  }
                                }(),
                                SizedBox(
                                  width: 18.0,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        () {
                                          if (state.fileAttachment != null) {
                                            return 'Добавлен файл';
                                          } else if (state.attachedLink !=
                                              null) {
                                            return 'Добавлена внешняя ссылка';
                                          }
                                        }(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      Text(
                                        () {
                                          if (state.fileAttachment != null) {
                                            return state
                                                    .fileAttachment?.filePath ??
                                                '';
                                          } else if (state.attachedLink !=
                                              null) {
                                            return state
                                                .attachedLink.linkContent;
                                          }
                                        }(),
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 18.0,
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 32.0,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (state.fileAttachment != null) {
                                        return () => this
                                            .formBloc
                                            .eventController
                                            .sink
                                            .add(RemoveFileAttachmentEvent());
                                      } else if (state.attachedLink != null) {
                                        return () => this
                                            .formBloc
                                            .eventController
                                            .sink
                                            .add(RemoveExternalLinkEvent());
                                      }
                                    }())
                              ],
                            )));
                  }

                  return SizedBox.shrink();
                })
          ],
        ));
  }
}
