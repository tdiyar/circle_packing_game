import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';

import 'draggable_ball.dart';
import 'wall.dart'; // createBoundaries
import 'shape_to_fill.dart'; // ShapeToFill
import 'constantCircleSizes.dart'; // SIZES_FOR_SQUARE
import 'package:provider/provider.dart';
import '../main.dart';

class CirlePackingGame extends Forge2DGame
    with HasDraggableComponents, HasTappableComponents {
  int shapeId;
  int numberOfBalls;
  double sizeOfSquar = 140.0;
  List<DraggableBall> balls = <DraggableBall>[];
  ShapeToFill? shape;
  BuildContext context;
  final tolerance = 50;
  @override
  CirlePackingGame(this.shapeId, this.numberOfBalls, this.context)
      : super(gravity: Vector2.all(0.0), zoom: 1.0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    final center = screenToWorld(viewport.effectiveSize / 2);

    assert(numberOfBalls > 0);

    final area_1 = 4 *
        ((sizeOfSquar - tolerance) / SIZES_FOR_SQUARE[numberOfBalls - 1]) *
        ((sizeOfSquar - tolerance) / SIZES_FOR_SQUARE[numberOfBalls - 1]);
    print(area_1);

    Vector2 position = center - Vector2(190, 250);
    final offSetXEach = 350 / this.numberOfBalls;

    shape = ShapeToFill(center, shapeId, sizeOfSquar);
    for (int i = 0; i < this.numberOfBalls; i++) {
      double radius = sqrt(area_1 * (i + 1));
      position += Vector2(offSetXEach, 40 * (i % 4));
      balls.add(DraggableBall(position, radius, shape!));
      position += Vector2(0, -40 * (i % 4));
    }
    add(shape!);
    balls.forEach((element) {
      add(element);
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (checkWinCondition()) {
      var level_array = context.read<JustWon>();
      level_array.update_level(shapeId, numberOfBalls - 1);
      print("YOU WON!!!");
      pauseEngine();
      showAlertDialog(context, shapeId);
    }
  }

  bool checkWinCondition() {
    bool ans = true;
    int ballsIn = 0;
    balls.forEach((ball) {
      if (ball.inSide) {
        ballsIn += 1;
      }
      if (!ball.inSide) {
        ans = false;
      }
    });

    print("$ballsIn, out of  $numberOfBalls!");

    return ans;
  }
}

showAlertDialog(BuildContext context, int shapeId) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LevelSelect(shapeId),
        ),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Congratulations! You passed this level."),
    content: Text("Oh my, this dude is doing it!!"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
