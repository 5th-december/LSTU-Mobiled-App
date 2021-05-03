import 'package:flutter/foundation.dart';

abstract class ProducingEvent<T> {
  T resourse;
  ProducingEvent({this.resourse});
}

class ProducerInitEvent<T> extends ProducingEvent<T> {
  ProducerInitEvent({T resource}): super(resourse: resource);
}

class ProduceResourceEvent<TR, TC> extends ProducingEvent<TR> {
  TC command;
  ProduceResourceEvent({@required this.command, TR resource}): super(resourse: resource);
}
