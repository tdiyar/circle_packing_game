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

    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: SafeArea(
        child: GameWidget(
          game: CirlePackingGame(shapeId, numberOfBalls, context),
        ),
      ),
    );

    // MaterialApp(
    //   home: Scaffold(
    //     body: SafeArea(
    //       child: GameWidget(
    //         game: CirlePackingGame(shapeId, numberOfBalls, context),
    //       ),
    //     ),
    //   ),
    // );
  }
}
