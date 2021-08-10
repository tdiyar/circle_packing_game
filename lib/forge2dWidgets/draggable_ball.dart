import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart' hide Draggable;
import 'package:flutter/material.dart' hide Draggable;
import 'package:flutter/widgets.dart' hide Draggable;
import 'package:forge2d/forge2d.dart';

import 'package:flame/extensions.dart';
import 'package:flame/gestures.dart';

import 'dart:math' as math;

import 'package:flame/palette.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame/game.dart';

import 'shape_to_fill.dart';

class DraggableBall extends Ball with Draggable {
  ShapeToFill shape;
  double yOffSet;
  DraggableBall(Vector2 position, double radius, this.shape, this.yOffSet)
      : super(position, radius: radius) {
    originalPaint = Paint()..color = Colors.amber;
    paint = isCollidabe ? originalPaint : paintCollide;
  }

  Paint paintCollide = Paint()..color = Colors.deepPurpleAccent;
  Paint paintCollide1 = Paint()..color = Colors.deepPurpleAccent.shade200;
  Paint originalPaint1 = Paint()..color = Colors.amber.shade200;

  bool dragOn = false;
  bool isCollidabe = true;
  bool beenTappedToStayNotCollidable = false;
  Vector2 touch = Vector2(0, 0);
  Vector2 initialTouchOffSet = Vector2(0, 0);

  bool inSide = false;
  bool justInSide = false;
  int countFrame = 0;

  bool isInSideShape() {
    return shape.IsBallInSide(this);
  }

  bool isJustInSideShape() {
    return shape.isJustInSideShape(this);
  }

  double force = 10;

  @override
  void update(double dt) {
    countFrame += 1;
    justInSide = isJustInSideShape();
    inSide = isInSideShape() && (!isCollidabe);
    MassData mass = body.getMassData();
    mass.mass = justInSide ? 1 : 0.5;
    body.setMassData(mass);
    body.linearDamping = isCollidabe ? 2.6 : 22.6;
    force = isCollidabe ? 26 : 2;
    Vector2 worldDelta;

    if (dragOn) {
      worldDelta = body.position - touch + initialTouchOffSet;

      worldDelta = worldDelta * worldDelta.length;
      worldDelta.scale(-force);
      body.applyForce(worldDelta);
      // body.applyLinearImpulse(worldDelta);
    } else {
      if (isCollidabe) {
        if (!beenTappedToStayNotCollidable) {
          if (DoesNotOverlapWithOthers()) {
            isCollidabe = false;
            paint = isCollidabe ? originalPaint : paintCollide;
            body.fixtures.forEach((element) {
              element.setSensor(false);
            });
          }
        }
      }
    }
    super.update(dt);
    // print("$dt - time dt - in dranggle ball");
  }

  @override
  Future<void> onLoad() {
    // TODO: implement onLoad
    Future<void> ret = super.onLoad();

    if (!isCollidabe) {
      isCollidabe = true;
      body.fixtures.forEach((element) {
        element.setSensor(true);
      });
    } else {
      if (DoesNotOverlapWithOthers()) {
        isCollidabe = false;
        body.fixtures.forEach((element) {
          element.setSensor(false);
        });
      }
    }
    paint = isCollidabe ? originalPaint : paintCollide;
    return ret;
  }

  // ignore: non_constant_identifier_names
  bool DoesNotOverlapWithOthers() {
    if (body.contacts.isEmpty) {
      return true;
    }
    bool ans = true;
    body.contacts.forEach((element) {
      if (element.isTouching()) {
        ans = false;
      }
    });
    return ans;
  }

  bool onTapDone() {
    if (!isCollidabe) {
      isCollidabe = !isCollidabe;
      beenTappedToStayNotCollidable = true;
      body.fixtures.forEach((element) {
        element.setSensor(true);
      });
    } else {
      beenTappedToStayNotCollidable = false;

      if (DoesNotOverlapWithOthers()) {
        beenTappedToStayNotCollidable = false;
        isCollidabe = !isCollidabe;
        body.fixtures.forEach((element) {
          element.setSensor(false);
        });
      }
    }
    paint = isCollidabe ? originalPaint : paintCollide;
    return true;
  }

  @override
  bool onDragStart(int pointerId, DragStartInfo details) {
    countFrame = 0;
    // TODO: Change this to normal; 80???

    touch = Vector2(details.raw.localPosition.dx,
        -(details.raw.localPosition.dy - yOffSet));
    initialTouchOffSet = touch - body.position;
    initialTouchOffSet = initialTouchOffSet - Vector2(0, yOffSet); //yOffSet

    paint = isCollidabe ? originalPaint1 : paintCollide1;
    dragOn = true;

    return true;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo details) {
    touch = Vector2(details.raw.localPosition.dx,
        -(details.raw.localPosition.dy - yOffSet));
    return true;
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo details) {
    dragOn = false;

    if (countFrame < 10) {
      onTapDone();
    } else {
      if (DoesNotOverlapWithOthers()) {
        isCollidabe = false;
        paint = isCollidabe ? originalPaint : paintCollide;
        body.fixtures.forEach((element) {
          element.setSensor(isCollidabe);
        });
      }
    }

    return true;
  }
}

class Ball extends BodyComponent {
  late Paint originalPaint;
  bool giveNudge = false;
  final double radius;
  final Vector2 _position;
  bool speed;
  double angularDamping;

  final Paint _blue = BasicPalette.blue.paint();

  Ball(this._position,
      {this.radius = 2, this.speed = false, this.angularDamping = 0}) {
    originalPaint = Paint()..color = Colors.teal.shade200;
    paint = originalPaint;
  }

  @override
  Body createBody() {
    final shape = CircleShape();
    shape.radius = radius;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.5
      ..density = 0.01
      ..friction = 0.0;

    final bodyDef = BodyDef()
      // To be able to determine object in collision
      ..userData = this
      ..angularDamping = .8
      ..linearDamping = angularDamping
      ..position = _position
      ..type = BodyType.dynamic
      ..linearVelocity = speed
          ? Vector2(400 * (math.Random().nextDouble() - 0.5),
              400 * (math.Random().nextDouble() - 0.5))
          : Vector2(0, 0);

    Body bodyRet = world.createBody(bodyDef)..createFixture(fixtureDef);
    return bodyRet;
  }

  @override
  void renderCircle(Canvas c, Offset center, double radius) {
    super.renderCircle(c, center, radius);
    // final lineRotation = Offset(0, radius);
    // c.drawLine(center, center + lineRotation, _blue);
  }
}
