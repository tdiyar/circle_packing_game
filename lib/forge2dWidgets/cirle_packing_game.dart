import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';

import 'draggable_ball.dart';
import 'wall.dart'; // createBoundaries
import 'shape_to_fill.dart'; // ShapeToFill

class CirlePackingGame extends Forge2DGame
    with HasDraggableComponents, HasTappableComponents {
  int shapeId;
  int numberOfBalls;
  double sizeOfSquar = 140.0;

  final sizes = <double>[
    2.0062815324405303,
    4.133087230375679,
    5.386153048372581,
    6.792800755181921,
    8.230467276712174,
    9.388098856997482,
    10.792792275814636,
    12.237876134479011,
    14.352105775714026,
    15.435604814013534,
    16.4228693610223,
    17.52890435071871,
    19.741873435408316,
    20.838408802849305,
    21.708037636748028,
    23.891172328897884,
    24.96719256968056,
    26.235535356600572,
    27.696806899096718,
    28.71703451903279,
  ];

  @override
  CirlePackingGame(this.shapeId, this.numberOfBalls)
      : super(gravity: Vector2.all(0.0), zoom: 1.0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    final center = screenToWorld(viewport.effectiveSize / 2);

    assert(numberOfBalls > 0);

    final area_1 = 3.14159265 *
        (sizeOfSquar / sizes[numberOfBalls - 1]) *
        (sizeOfSquar / sizes[numberOfBalls - 1]);
    print(area_1);

    Vector2 position = center - Vector2(0, 250);
    for (int i = 0; i < this.numberOfBalls; i++) {
      double radius = sqrt(area_1 * (i + 1));
      add(DraggableBall(position, radius));
      add(ShapeToFill(center, shapeId));
      position += Vector2(-10, 0);
    }
  }
}
