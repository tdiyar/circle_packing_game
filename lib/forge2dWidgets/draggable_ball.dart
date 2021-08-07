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
  DraggableBall(Vector2 position, double radius, this.shape)
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
  Vector2 touchInitial = Vector2(0, 0);
  Vector2 initialTouchOffSet = Vector2(0, 0);
  double yOffSet = 100;
  bool inSide = false;
  bool justInSide = false;

  bool isInSideShape() {
    return shape.IsBallInSide(this);
  }

  bool isJustInSideShape() {
    return shape.isJustInSideShape(this);
  }

  double force = 10;

  int frameCount = 0;

  @override
  void update(double dt) {
    frameCount += 1;
    justInSide = isJustInSideShape();
    inSide = isInSideShape() && (!isCollidabe);
    MassData mass = body.getMassData();
    mass.mass = justInSide ? 1 : 0.1;
    body.setMassData(mass);
    body.linearDamping = justInSide ? 22.6 : 12.6;
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

  // ignore: non_constant_identifier_names
  bool TapHappended() {
    print("TAP");

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
    // TODO: Change this to normal; 80???
    touchInitial =
        Vector2(details.raw.localPosition.dx, -(details.raw.localPosition.dy));
    touch =
        Vector2(details.raw.localPosition.dx, -(details.raw.localPosition.dy));
    initialTouchOffSet = touch - body.position;

    paint = isCollidabe ? originalPaint1 : paintCollide1;
    dragOn = true;
    frameCount = 0;

    return true;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo details) {
    touch =
        Vector2(details.raw.localPosition.dx, -(details.raw.localPosition.dy));
    return true;
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo details) {
    dragOn = false;
    if (DoesNotOverlapWithOthers()) {
      isCollidabe = false;
      paint = isCollidabe ? originalPaint : paintCollide;
      body.fixtures.forEach((element) {
        element.setSensor(false);
      });
    }

    if (frameCount < 5) {
      TapHappended();
    }

    return true;
  }
}

class Ball extends BodyComponent {
  late Paint originalPaint;
  bool giveNudge = false;
  final double radius;
  final Vector2 _position;

  final Paint _blue = BasicPalette.blue.paint();

  Ball(this._position, {this.radius = 2}) {
    originalPaint = randomPaint();
    paint = originalPaint;
  }

  Paint randomPaint() {
    final rng = math.Random();
    return PaletteEntry(
      Color.fromARGB(
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        255,
      ),
    ).paint();
  }

  @override
  Body createBody() {
    final shape = CircleShape();
    shape.radius = radius;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.5
      ..density = 0.1 / (radius * radius)
      ..friction = 0.0;

    final bodyDef = BodyDef()
      // To be able to determine object in collision
      ..userData = this
      ..angularDamping = 1.8
      ..linearDamping = .8
      ..position = _position
      ..type = BodyType.dynamic;

    Body bodyRet = world.createBody(bodyDef)..createFixture(fixtureDef);

    MassData mass = bodyRet.getMassData();
    mass.mass = 0.0001;
    bodyRet.setMassData(mass);

    return bodyRet;
  }

  @override
  void renderCircle(Canvas c, Offset center, double radius) {
    super.renderCircle(c, center, radius);
    final lineRotation = Offset(0, radius);
    c.drawLine(center, center + lineRotation, _blue);
  }
}
