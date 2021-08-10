import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart' hide Draggable;
import 'package:flutter/material.dart' hide Draggable;
import 'package:flutter/widgets.dart' hide Draggable;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'theme_select.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import '../forge2dWidgets/draggable_ball.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/extensions.dart';

import '../forge2dWidgets/wall.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void goToThemeSelect() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ThemeSelect()),
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: SafeArea(
        child: GameWidget(
          game: MainMenuGame(goToThemeSelect),
        ),
      ),
    );
  }
}

class MainMenuGame extends Forge2DGame with HasDraggableComponents {
  Function goToThemeSelect;
  @override
  MainMenuGame(this.goToThemeSelect)
      : super(gravity: Vector2.all(0.0), zoom: 1.0);

  @override
  Future<void> onLoad() async {
    Vector2 position = screenToWorld(viewport.effectiveSize / 2);
    double radius = 120;
    await super.onLoad();

    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    int numberOfBalls = 30;
    add(DraggablePlayButtonBall(position, radius, goToThemeSelect));
    position = position - Vector2(190, 250);
    for (int i = 0; i < numberOfBalls; i++) {
      position += Vector2(350 / numberOfBalls, 180 * (i % 4));
      add(Ball(position, radius: 7, speed: true));
      position += Vector2(0, -180 * (i % 4));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    world.stepDt(dt);
    world.stepDt(dt);
    world.stepDt(dt);
    world.stepDt(dt);
  }
}

class DraggablePlayButtonBall extends Ball with Draggable {
  Function goToThemeSelect;
  DraggablePlayButtonBall(Vector2 position, double radius, this.goToThemeSelect)
      : super(position, radius: radius, angularDamping: 0.8) {
    paint = Paint()..color = Colors.deepPurple.shade600;
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo details) {
    if (countFrame < 5) goToThemeSelect();
    dragOn = false;
    return true;
  }

  @override
  Future<void> onLoad() {
    // TODO: implement onLoad
    Future<void> ret = super.onLoad();

    body.angularDamping = 12000.8;
    return ret;
  }

  double yOffSet = 0;

  bool dragOn = false;
  Vector2 touch = Vector2(0, 0);
  Vector2 initialTouchOffSet = Vector2(0, 0);
  int countFrame = 0;

  @override
  // ignore: must_call_super
  void update(double dt) {
    countFrame += 1;
    Vector2 worldDelta;
    if (dragOn) {
      worldDelta = body.position - touch + initialTouchOffSet;
      worldDelta = worldDelta * worldDelta.length;
      worldDelta.scale(-10);
      body.applyForce(worldDelta);
      // body.applyLinearImpulse(worldDelta);
    }
  }

  @override
  bool onDragStart(int pointerId, DragStartInfo details) {
    countFrame = 0;
    touch = Vector2(details.raw.localPosition.dx,
        -(details.raw.localPosition.dy - yOffSet));
    initialTouchOffSet = touch - body.position;
    initialTouchOffSet = initialTouchOffSet - Vector2(0, yOffSet); //yOffSet
    dragOn = true;

    return true;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo details) {
    touch = Vector2(details.raw.localPosition.dx,
        -(details.raw.localPosition.dy - yOffSet));
    return true;
  }

  void renderCircle(Canvas c, Offset center, double radius) {
    super.renderCircle(c, center, radius);

    final icon = Icons.play_arrow;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: Colors.teal.shade200,
        fontSize: radius,

        fontFamily: icon.fontFamily,
        package:
            icon.fontPackage, // This line is mandatory for external icon packs
      ),
    );

    textPainter.layout();
    final lineRotation =
        Offset(-textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(c, lineRotation);

    // c.drawLine(center, center + lineRotation, _blue);
  }
}









// class MainMenu extends StatelessWidget {
//   const MainMenu({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Main menu'),
//       ),
//       body: Center(
//         child: FloatingActionButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ThemeSelect()),
//               );
//               print("fuck murad");
//             },
//             child: Icon(Icons.play_arrow)),
//       ),
//     );
//   }
// }
