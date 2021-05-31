import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String apiBase;
  final String apiVersion;
  final bool useHttps;
  final String rmqHost;
  final String rmqPort;
  final String rmqUsername;
  final String rmqVHost;
  final String rmqPassword;

  AppConfig._(
      {this.apiBase,
      this.apiVersion,
      this.useHttps,
      this.rmqHost,
      this.rmqPassword,
      this.rmqPort,
      this.rmqUsername,
      this.rmqVHost});

  factory AppConfig._fromJson(Map<String, dynamic> json) {
    return AppConfig._(
        apiBase: json['apiBase'],
        apiVersion: json['apiVersion'],
        useHttps: json['useHttps'] == 0 ? false : true,
        rmqHost: json['rmqHost'],
        rmqPassword: json['rmqPassword'],
        rmqPort: json['rmqPort'],
        rmqUsername: json['rmqUsername'],
        rmqVHost: json['rmqVHost']);
  }

  static Future<AppConfig> configure({String env = 'prod'}) async {
    final config = await rootBundle.loadString("assets/config/$env.json");
    Map<String, dynamic> json = jsonDecode(config);
    return AppConfig._fromJson(json);
  }
}
