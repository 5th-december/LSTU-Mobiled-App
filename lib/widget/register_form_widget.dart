import 'package:flutter/material.dart';

class RegisterFormWidget extends StatelessWidget
{
  RegisterFormWidget();

  @override
  Widget build(BuildContext context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ФИО'
                  ),
                  autofocus: true,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Номер зачетной книжки'
                  )
                ), 
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Год поступления'
                  )
                ), 
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: RaisedButton(
                    child: Text('Далее'),
                    onPressed: null
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}