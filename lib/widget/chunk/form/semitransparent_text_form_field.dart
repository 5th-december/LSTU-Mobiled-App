import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SemitransparentTextFormField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final String errorText;

  SemitransparentTextFormField(
      {this.icon, this.hintText, this.errorText, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              borderSide: BorderSide(color: Colors.red.shade600)),
          errorStyle: TextStyle(color: Colors.red.shade600),
          errorText: this.errorText,
          prefixIcon:
              Icon(this.icon, color: Color.fromRGBO(167, 155, 254, 1.0)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              borderSide: BorderSide.none),
          hintStyle: TextStyle(color: Color.fromRGBO(167, 155, 254, 1.0)),
          filled: true,
          fillColor: Color.fromRGBO(244, 244, 244, 1.0),
          hintText: this.hintText),
    );
  }
}
