import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lk_client/bloc/attached/attached_form_bloc.dart';

class StudentTaskResponse extends StatefulWidget {
  StudentTaskResponse({Key key}) : super(key: key);

  @override
  State<StudentTaskResponse> createState() => StatefulTaskResponseState();
}

class StatefulTaskResponseState extends State<StudentTaskResponse> {
  AttachedFormBloc attachedFormBloc;

  Widget getAttachmentTypeSelection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            ElevatedButton(
                onPressed: () => {},
                child: Icon(Icons.download_rounded, size: 36.0),
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
                onPressed: () => {},
                child: Icon(Icons.download_rounded, size: 36.0),
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

  Widget getRemoveButtonWidget() {
    return ElevatedButton(
        child: Icon(Icons.close_rounded, size: 12.0),
        style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(180, 180, 180, 1.0),
            shape: CircleBorder(),
            padding: EdgeInsets.all(12.0)));
  }

  Widget getExternalLinkAttachmentForm() {
    GlobalKey key = GlobalKey();
    TextEditingController externalLinkTextController = TextEditingController();

    return Form(
      key: key,
      child: Row(
        children: [
          TextFormField(
            controller: externalLinkTextController,
            decoration: InputDecoration(
                fillColor: Color.fromRGBO(212, 212, 212, 1.0),
                hintText: 'Ссылка на внешний ресурс'),
          ),
          getRemoveButtonWidget()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey formKey = GlobalKey();
    TextEditingController attachmentNameEditingController =
        TextEditingController();

    return Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: attachmentNameEditingController,
              decoration: InputDecoration(
                fillColor: Color.fromRGBO(212, 212, 212, 1.0),
                hintText: 'Название ответа',
              ),
            )
          ],
        ));
  }
}
