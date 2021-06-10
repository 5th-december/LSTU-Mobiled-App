import 'package:flutter/material.dart';

ThemeData lkAppTheme() => ThemeData(
      primaryColor: Colors.white,
      accentColor: Color.fromRGBO(139, 65, 243, 1.0),
      iconTheme:
          IconThemeData(size: 22.0, color: Color.fromRGBO(76, 72, 84, 1.0)),
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
          headline5: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(42, 38, 52, 1.0)),
          headline4: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(42, 38, 52, 1.0)),
          headline3: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w800,
              color: Color.fromRGBO(42, 38, 52, 1.0)),
          headline2: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w800,
              color: Color.fromRGBO(42, 38, 52, 1.0)),
          subtitle1: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(76, 72, 84, 1.0)),
          subtitle2: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(179, 179, 179, 1.0)),
          bodyText1: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(42, 38, 52, 1.0)),
          bodyText2: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(179, 179, 179, 1.0))),
    );
