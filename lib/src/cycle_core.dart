library cycle_dart_flutter.core;

import 'dart:async';
import 'package:rxdart/rxdart.dart' as Rx;

callDrivers(drivers, sinkProxies){
  var sources = {};
  drivers.forEach((key, driver) {
    sources[key] = driver(sinkProxies[key]);
  });
  return sources;
}

run(mainFn, drivers){
  Map<String, StreamController> proxyControllers = {};
  Map <String, Rx.Observable> sinkProxies = {};
  drivers.forEach((key, _){
    StreamController controller = new StreamController.broadcast();
    proxyControllers[key] = controller;
    sinkProxies[key] = Rx.observable(controller.stream);
  });
  var sources = callDrivers(drivers, sinkProxies);
  var sinks = mainFn(sources);

  sinks.forEach((key, sink) {
    proxyControllers[key].addStream(sink);
  });
}
