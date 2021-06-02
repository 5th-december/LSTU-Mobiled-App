import 'dart:convert';

import 'package:flutter/services.dart';

class AmqpConfig {
  final String rmqHost;
  final String rmqPort;
  final String rmqUsername;
  final String rmqVHost;
  final String rmqPassword;
  final String messageExchangeName;
  final String dialogListExchangeName;
  final String dialogReadExchangeName;
  final String discussionMessageExchangeName;

  AmqpConfig._(
      {this.rmqHost,
      this.rmqPassword,
      this.rmqPort,
      this.rmqUsername,
      this.rmqVHost,
      this.dialogListExchangeName,
      this.dialogReadExchangeName,
      this.discussionMessageExchangeName,
      this.messageExchangeName});

  factory AmqpConfig._fromJson(Map<String, dynamic> json) {
    return AmqpConfig._(
        rmqHost: json['rmqHost'],
        rmqPassword: json['rmqPassword'],
        rmqPort: json['rmqPort'],
        rmqUsername: json['rmqUsername'],
        rmqVHost: json['rmqVHost'],
        dialogListExchangeName: json['exchange']['dialogListExchangeName'],
        dialogReadExchangeName: json['exchange']['dialogReadExchangeName'],
        discussionMessageExchangeName: json['exchange']
            ['discussionMessageExchangeName'],
        messageExchangeName: json['exchange']['messageExchangeName']);
  }

  static Future<AmqpConfig> configure() async {
    final config = await rootBundle.loadString("assets/config/amqp.json");
    Map<String, dynamic> json = jsonDecode(config);
    return AmqpConfig._fromJson(json);
  }
}
