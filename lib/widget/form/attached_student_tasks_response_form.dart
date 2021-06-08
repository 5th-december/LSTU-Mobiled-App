import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/single_type_attachment_form_bloc.dart';
import 'package:lk_client/bloc/proxy/abstract_attached_form_transport_proxy_bloc.dart';
import 'package:lk_client/event/attached_form_event.dart';
import 'package:lk_client/state/attached_form_state.dart';
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
      mainAxisSize: MainAxisSize.min,
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
                child: Icon(Icons.description_rounded, size: 36.0),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(139, 62, 252, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12.0))),
            Text('Документ')
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
                child: Icon(Icons.public_rounded, size: 36.0),
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(139, 62, 252, 1.0),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12.0))),
            Text('Внешняя ссылка')
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
          TextFormField(
            controller: externalLinkTextController,
            decoration: InputDecoration(
                fillColor: Color.fromRGBO(212, 212, 212, 1.0),
                hintText: 'Ссылка на внешний ресурс'),
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
            TextFormField(
              controller:
                  this.controllerProvider.responseNameTextEditionController,
              decoration: InputDecoration(
                fillColor: Color.fromRGBO(212, 212, 212, 1.0),
                hintText: 'Название ответа',
              ),
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

                    if (state.fileAttachment != null) {
                      return Row(
                        children: [
                          Icon(Icons.description_rounded, size: 36.0),
                          IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => this
                                  .formBloc
                                  .eventController
                                  .sink
                                  .add(RemoveFileAttachmentEvent()))
                        ],
                      );
                    }

                    if (state.attachedLink != null) {
                      return Row(
                        children: [
                          Icon(
                            Icons.public_rounded,
                            size: 36.0,
                          ),
                          IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => this
                                  .formBloc
                                  .eventController
                                  .sink
                                  .add(RemoveExternalLinkEvent()))
                        ],
                      );
                    }
                  }

                  return SizedBox.shrink();
                })
          ],
        ));
  }
}
