import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/game.dart';

import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/extensions.dart';

import 'draggable_ball.dart';

class ShapeToFill extends BodyComponent {
  Vector2 worldCenter;
  int shapeId;
  double sizeOfSquar;

  ShapeToFill(this.worldCenter, this.shapeId, this.sizeOfSquar);

  // ignore: non_constant_identifier_names
  bool IsBallInSide(DraggableBall ball) {
    double radius = ball.radius;
    double xball = ball.body.position.x;
    double yball = ball.body.position.y;

    double sizeOfSquarTemp = sizeOfSquar - radius;

    bool inX = (xball <= (worldCenter.x + sizeOfSquarTemp)) &&
        (xball >= (worldCenter.x - sizeOfSquarTemp));
    bool inY = (yball <= (worldCenter.y + sizeOfSquarTemp)) &&
        (yball >= (worldCenter.y - sizeOfSquarTemp));

    return inY && inX;
  }

  bool isJustInSideShape(DraggableBall ball) {
    double radius = 0;
    double xball = ball.body.position.x;
    double yball = ball.body.position.y;

    double sizeOfSquarTemp = sizeOfSquar - radius;

    bool inX = (xball <= (worldCenter.x + sizeOfSquarTemp)) &&
        (xball >= (worldCenter.x - sizeOfSquarTemp));
    bool inY = (yball <= (worldCenter.y + sizeOfSquarTemp)) &&
        (yball >= (worldCenter.y - sizeOfSquarTemp));

    return inY && inX;
  }

  @override
  Body createBody() {
    if (shapeId == 0) {
      // print("making a square");
    }
    worldCenter = worldCenter + Vector2(0, 100);

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
