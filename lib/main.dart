import 'package:flutter/material.dart';
import 'app.dart';
import 'store/app_state_container.dart';
import 'service/app_init.dart';

Future<void> main() async {
  await AppInit.initApp();

  runApp(AppStateContainer(
    child: LkApp(),
    blocLibrary: null,
  ));
}
