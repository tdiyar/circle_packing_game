import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/game.dart';

import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/extensions.dart';

class ShapeToFill extends BodyComponent {
  Vector2 worldCenter;
  int shapeId;

  ShapeToFill(this.worldCenter, this.shapeId);

  @override
  Body createBody() {
    if (shapeId == 0) {
      print("making a square");
    }
    worldCenter = worldCenter + Vector2(0, 100);
    double sizeOfSquar = 140.0;
    final shape = PolygonShape();
    shape.setAsBox(sizeOfSquar, 0.4, Vector2(0.0, -sizeOfSquar), 0.0);
    final bodyDef = BodyDef();
    bodyDef.position.setFrom(worldCenter);
    final ground = world.createBody(bodyDef);
    ground.createFixtureFromShape(shape);

    shape.setAsBox(0.4, sizeOfSquar, Vector2(-sizeOfSquar, 0.0), 0.0);
    ground.createFixtureFromShape(shape);
    shape.setAsBox(0.4, sizeOfSquar, Vector2(sizeOfSquar, 0.0), 0.0);
    ground.createFixtureFromShape(shape);
    shape.setAsBox(sizeOfSquar, 0.4, Vector2(0.0, sizeOfSquar), 0.0);
    ground.createFixtureFromShape(shape);
    return ground;
  }
}
