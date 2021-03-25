import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String apiBase;
  final String apiVersion;
  final bool useHttps;

  AppConfig._({this.apiBase, this.apiVersion, this.useHttps});

  factory AppConfig._fromJson(Map<String, dynamic> json) {
    return AppConfig._(
        apiBase: json['apiBase'],
        apiVersion: json['apiVersion'],
        useHttps: json['useHttps'] == 0 ? false : true);
  }

  static Future<AppConfig> configure({String env = 'prod'}) async {
    final config = await rootBundle.loadString("assets/config/$env.json");
    Map<String, dynamic> json = jsonDecode(config);
    return AppConfig._fromJson(json);
  }
}
