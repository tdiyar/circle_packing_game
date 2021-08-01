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
  @override
  CirlePackingGame(this.shapeId, this.numberOfBalls)
      : super(gravity: Vector2.all(0.0), zoom: 1.0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    final center = screenToWorld(viewport.effectiveSize / 2);
    Vector2 position = center - Vector2(0, 250);
    for (int i = 0; i < this.numberOfBalls; i++) {
      double radius = sqrt(200.0 * (i + 1));
      add(DraggableBall(position, radius));
      add(ShapeToFill(center, shapeId));
      position += Vector2(-10, 0);
    }
  }
}
