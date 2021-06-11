import 'dart:convert';

import 'package:flutter/services.dart';

class AmqpConfig {
  final String rmqHost;
  final String rmqPort;
  final String rmqUsername;
  final String rmqVHost;
  final String rmqPassword;
  final String privateMessageUpdateExchangeName;
  final String privateMessageListExchangeName;
  final String dialogListExchangeName;
  final String discussionMessageUpdateExchangeName;
  final String discussionMessageListExchangeName;

  AmqpConfig._(
      {this.rmqHost,
      this.rmqPassword,
      this.rmqPort,
      this.rmqUsername,
      this.rmqVHost,
      this.dialogListExchangeName,
      this.discussionMessageListExchangeName,
      this.discussionMessageUpdateExchangeName,
      this.privateMessageListExchangeName,
      this.privateMessageUpdateExchangeName});

  factory AmqpConfig._fromJson(Map<String, dynamic> json) {
    return AmqpConfig._(
        rmqHost: json['rmqHost'],
        rmqPassword: json['rmqPassword'],
        rmqPort: json['rmqPort'],
        rmqUsername: json['rmqUsername'],
        rmqVHost: json['rmqVHost'],
        dialogListExchangeName: json['exchange']['dialogListExchangeName'],
        privateMessageListExchangeName: json['exchange']
            ['privateMessageListExchangeName'],
        privateMessageUpdateExchangeName: json['exchange']
            ['privateMessageUpdateExchangeName'],
        discussionMessageListExchangeName: json['exchange']
            ['discussionMessageListExchangeName'],
        discussionMessageUpdateExchangeName: json['exchange']
            ['discussionMessageUpdateExchangeName']);
  }

  static Future<AmqpConfig> configure() async {
    final config = await rootBundle.loadString("assets/config/amqp.json");
    Map<String, dynamic> json = jsonDecode(config);
    return AmqpConfig._fromJson(json);
  }
}
