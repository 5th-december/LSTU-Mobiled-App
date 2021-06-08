import 'package:flutter/material.dart';

ThemeData lkAppTheme() => ThemeData(
    primaryColor: Colors.white,
    accentColor: Color.fromRGBO(139, 65, 243, 1.0),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(137, 64, 253, 1.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                    side: BorderSide.none)))),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Color.fromRGBO(139, 65, 243, 1.0)),
    textTheme: TextTheme(
        headline3: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w800,
            color: Color.fromRGBO(42, 38, 52, 1.0)),
        subtitle1: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(146, 146, 144, 1.0))));
