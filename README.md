# Cycle Dart Flutter

An experiment in using a [Cycle.js](http://cycle.js.org/) like architecture for data flow and reactive UI.

This package provides a Cycle driver for [Flutter]( http://flutter.io), which allows you to render to
iOS and Android. 

## Usage

A simple click counter:

    import 'package:flutter/material.dart';
    import 'package:cycle_dart_flutter/src/cycle_flutter.dart';
    import 'package:cycle_dart_flutter/src/cycle_core.dart' as Cycle;
    
    
    main() {
      Cycle.run(app, {
        'flutter': flutterDriver
      });
    }
    
    app(sources){
      FlutterDriver flutter = sources['flutter'];
      return {
        'flutter': flutter.listen('increment')
            .map((e) => 1)
            .scan((int acc, int value, int index) => ((acc == null) ? 0 : acc) + value)
            .startWith([0])
            .map((count) => new Material(child:
        new RaisedButton(
            onPressed: () => flutter.dispatch('increment'),
            child:
              new Text('Clicked $count times')
            ))
        )
      };
    }
    
Cycle offers great slicability. Alternative structure:

    app(sources){
      FlutterDriver flutter = sources['flutter'];
      return {
        'flutter': view(model(intent(flutter.listen)), flutter.dispatch)
      };
    }
    
    intent(listen) => listen('increment')
        .map((e) => 1);
    
    model(intent$) => intent$
        .scan((int acc, int value, int index) => ((acc == null) ? 0 : acc) + value)
        .startWith([0]);
    
    view(model$, dispatch) => model$
        .map((count) => new Material(child:
          new RaisedButton(
          onPressed: () => dispatch('increment'),
          child:
            new Text('Clicked $count times')
          ))
        );
        
##Flutter Setup

Follow the [getting started](https://flutter.io/getting-started/) guide. 
Flutter is included as a submodule under `lib/flutter`.
