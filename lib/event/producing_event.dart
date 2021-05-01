import 'package:flutter/foundation.dart';

abstract class ProducingEvent<TR, TC> {}

class ProducerInitEvent<TR, TC> {
  TR resource;
  TC command;

  ProducerInitEvent({this.resource, this.command});
}

class ProduceResourceEvent<TR, TC> extends ProducingEvent<TR, TC> {
  TR resource;
  TC command;
  ProduceResourceEvent({@required this.command, this.resource});
}
