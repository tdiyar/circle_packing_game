import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'cirle_packing_game.dart';

import '/commonFiles/ScreenArguments.dart';

class MyGameApp extends StatelessWidget {
  MyGameApp() : super();

  @override
  Widget build(BuildContext context) {
    int shapeId = 0, numberOfBalls = 5;
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    shapeId = args.shapeId;
    numberOfBalls = args.numberOfBalls;

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: GameWidget(
          game: CirlePackingGame(shapeId, numberOfBalls, context),
        ),
      ),
    );
  }
}
