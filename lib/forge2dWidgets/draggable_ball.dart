import 'dart:math';

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

class DraggableBall extends Ball with Draggable, Tappable {
  DraggableBall(Vector2 position, double radius)
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
  double yOffSet = 80;

  @override
  void update(double dt) {
    super.update(dt);

    if (dragOn) {
      final worldDelta = Vector2(-1, -1)
        ..multiply(body.position - touch + initialTouchOffSet);
      body.applyForce(worldDelta * 800);
    } else {
      if (isCollidabe) {
        if (!beenTappedToStayNotCollidable) {
          if (body.contacts.isEmpty) {
            isCollidabe = false;
            paint = isCollidabe ? originalPaint : paintCollide;
            body.fixtures.forEach((element) {
              element.setSensor(false);
            });
          }
        }
      }
    }

    world.stepDt(dt);
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
      if (body.contacts.isEmpty) {
        isCollidabe = false;
        body.fixtures.forEach((element) {
          element.setSensor(false);
        });
      }
    }
    paint = isCollidabe ? originalPaint : paintCollide;
    return ret;
  }

  @override
  bool onTapUp(TapUpInfo details) {
    print("TAP");

    if (!isCollidabe) {
      isCollidabe = !isCollidabe;
      beenTappedToStayNotCollidable = true;
      body.fixtures.forEach((element) {
        element.setSensor(true);
      });
    } else {
      beenTappedToStayNotCollidable = false;
      if (body.contacts.isEmpty) {
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

    touch = Vector2(details.raw.localPosition.dx,
        -(details.raw.localPosition.dy - yOffSet));
    initialTouchOffSet = touch - body.position;
    initialTouchOffSet = initialTouchOffSet - Vector2(0, yOffSet);

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
    if (body.contacts.isEmpty) {
      isCollidabe = false;
      paint = isCollidabe ? originalPaint : paintCollide;
      body.fixtures.forEach((element) {
        element.setSensor(false);
      });
    }

    return true;
  }
}

class Ball extends BodyComponent {
  late Paint originalPaint;
  bool giveNudge = false;
  final double radius;
  final Vector2 _position;
  double _timeSinceNudge = 0.0;
  static const double _minNudgeRest = 2.0;

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
      ..density = 1.0 / (pow(radius, 2))
      ..friction = 0.8;

    final bodyDef = BodyDef()
      // To be able to determine object in collision
      ..userData = this
      ..angularDamping = 0.8
      ..linearDamping = 1.8
      ..position = _position
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void renderCircle(Canvas c, Offset center, double radius) {
    super.renderCircle(c, center, radius);
    final lineRotation = Offset(0, radius);
    c.drawLine(center, center + lineRotation, _blue);
  }

  @override
  void update(double t) {
    super.update(t);
    _timeSinceNudge += t;
    if (giveNudge) {
      giveNudge = false;
      if (_timeSinceNudge > _minNudgeRest) {
        body.applyLinearImpulse(Vector2(0, 1000));
        _timeSinceNudge = 0.0;
      }
    }
  }
}
