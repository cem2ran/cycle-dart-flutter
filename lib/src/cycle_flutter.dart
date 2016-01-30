library cycle_dart_flutter.driver;

import 'dart:async';
import 'package:rxdart/rxdart.dart' as Rx;

import 'package:flutter/material.dart';

class Event{
  final String type;
  final Object payload;

  const Event(this.type, this.payload);
}

class FlutterDriver{
  StreamController eventController;
  Rx.Observable event$;

  FlutterDriver(){
    eventController = new StreamController();
    event$ = Rx.observable(eventController.stream).asBroadcastStream();
  }

  Rx.Observable<Object> listen(String type) => event$.where((Event ev) => ev.type == type);

  dispatch(String type, [Object payload]){
    if(payload == null) payload = {};
    eventController.add(new Event(type, payload));
  }
}

flutterDriver(Rx.Observable view$){
  var driver = new FlutterDriver();
  view$.listen((view){
    runApp(view);
  });
  return driver;
}
