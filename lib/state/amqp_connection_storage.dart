import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:lk_client/service/amqp_service.dart';

class AmqpConnectionStorage {
  final AmqpService amqpService;
  final Map<String, Stream<Map<dynamic, dynamic>>> connectionStreamStorage;

  AmqpConnectionStorage(
      {@required this.amqpService,
      this.connectionStreamStorage =
          const <String, Stream<Map<dynamic, dynamic>>>{}});

  Future<Stream<Map<dynamic, dynamic>>> getConsumeStream(
      AmqpBindingData bindingData) async {
    if (this.connectionStreamStorage.containsKey('key')) {
      return this.connectionStreamStorage[''];
    }

    Consumer consumer =
        await this.amqpService.startListenBindedQueue(bindingData);

    consumer.
  }
}
