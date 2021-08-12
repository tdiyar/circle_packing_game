import 'dart:math';

import 'package:circle_packing/navigation/level_select.dart';
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

class CirlePackingGame extends Forge2DGame with HasDraggableComponents {
  int shapeId;
  int numberOfBalls;
  double sizeOfSquar = 140.0;
  List<DraggableBall> balls = <DraggableBall>[];
  ShapeToFill? shape;
  BuildContext context;
  double yOffSet = 0;
  final tolerance = 1;
  @override
  CirlePackingGame(this.shapeId, this.numberOfBalls, this.context)
      : super(gravity: Vector2.all(0.0), zoom: 1.0);

  @override
  Future<void> onLoad() async {
    yOffSet =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    // yOffSet = MediaQuery.of(context).padding.top; // without AppBar

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
      balls.add(DraggableBall(position, radius, shape!, yOffSet));
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
    world.stepDt(dt);
    world.stepDt(dt);
    world.stepDt(dt);
    world.stepDt(dt);

    // print("$dt - time dt");
    if (checkWinCondition()) {
      var levelArray = context.read<JustWon>();
      levelArray.update_level(shapeId, numberOfBalls - 1, true);
      pauseEngine();
      showAlertDialog(context, shapeId);
    }
  }

  bool checkWinCondition() {
    bool ans = true;
    balls.forEach((ball) {
      if (ball.inSide) {}
      if (!ball.inSide) {
        ans = false;
      }
    });
    // print("$ballsIn, out of  $numberOfBalls!");
    return ans;
  }
}

showAlertDialog(BuildContext context, int shapeId) {
  // set up the button
  Widget okButton = OutlinedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.purple.shade400),
    ),
    child: Text(
      "OK",
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 19),
    ),
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
      contentPadding: EdgeInsets.all(0),
      content: Container(
          color: Colors.teal,
          width: 148.0,
          height: 88.0,
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Center(
              child: Text(
                "You Passed This Level",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple),
              ),
            ),
            okButton,
          ])));

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
