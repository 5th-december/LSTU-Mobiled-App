import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SemitransparentTextFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final String errorText;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool autofocus;

  SemitransparentTextFormField(
      {this.icon,
      this.hintText,
      this.labelText,
      this.errorText,
      this.controller,
      this.autofocus = false,
      this.autocorrect = true,
      this.enableSuggestions = true,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      autocorrect: this.autocorrect,
      autofocus: this.autofocus,
      enableSuggestions: this.enableSuggestions,
      obscureText: this.obscureText,
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
          labelText: this.labelText,
          fillColor: Color.fromRGBO(244, 244, 244, 1.0),
          hintText: this.hintText),
    );
  }
}
