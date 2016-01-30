library cycle_dart_flutter.example;

import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/flex.dart';
import 'dart:async';

import 'package:rxdart/rxdart.dart' as Rx;

import 'package:cycle_dart_flutter/src/cycle_flutter.dart';
import 'package:cycle_dart_flutter/src/cycle_core.dart' as Cycle;


main() {
  Cycle.run(app, {
    'flutter': flutterDriver
  });
}


app(sources){
  FlutterDriver flutter = sources['flutter'];

  Rx.Observable increment$ = flutter.listen('increment').map((e) => 1);
  Rx.Observable reset$ = flutter.listen('reset');

  Stream getTimer$(num value) {
    return new Stream.periodic(new Duration(seconds: 1), (n) => n);
  }

  return {
    'flutter': new Rx.Observable.combineLatest([
      increment$
          .scan((int acc, int value, int index) => ((acc == null) ? 0 : acc) + value)
          .startWith([0]),
      reset$.map((e) => 0)
          .startWith([0])
          .flatMapLatest(getTimer$)
          .startWith([0])
    ], (count, time) => {'count': count, 'time': time})
        .map((state){
      var count = state['count'];
      var time = state['time'];

      return new Scaffold(
          toolBar: new ToolBar(
              center: new Text("Cycle+Dart+Flutter Demo")
          ),
          body: new Material(
              child: new Flex(
                  direction: FlexDirection.vertical,
                  justifyContent: FlexJustifyContent.center,
                  alignItems: FlexAlignItems.center,
                  children: [
                    new Text('Button tapped ${count} - times. ' ),
                    new Text('Count: ${time} ' ),
                    new RaisedButton(
                        onPressed: () => flutter.dispatch('reset'),
                        child: new Text('Reset timer')
                    )
                  ]
              )
          ),
          floatingActionButton: new FloatingActionButton(
              child: new Text("+"),
              onPressed: () => flutter.dispatch("increment")
          )
      );
    })
  };
}
