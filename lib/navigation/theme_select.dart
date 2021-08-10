import 'package:flame/palette.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:provider/provider.dart';

import 'level_select.dart';
import '../main.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart' hide Draggable;
import 'package:flutter/material.dart' hide Draggable;
import 'package:flutter/widgets.dart' hide Draggable;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/extensions.dart';

import '../forge2dWidgets/wall.dart';
import '../forge2dWidgets/draggable_ball.dart';

class ThemeSelect extends StatefulWidget {
  const ThemeSelect({Key? key}) : super(key: key);

  @override
  _ThemeSelectState createState() => _ThemeSelectState();
}

class _ThemeSelectState extends State<ThemeSelect> {
  final _themes = <String>[];

  void _buildThemes() {
    _themes.add('Rectangle');
  }

  @override
  Widget build(BuildContext context) {
    _buildThemes();
    final index = 0;
    final themeId = index;
    var level_array = context.read<JustWon>();
    int cnt = 0;
    for (int i = 0; i < level_array.levels[index].length; i++) {
      if (level_array.levels[index][i] == true) {
        cnt = cnt + 1;
      }
    }
    void goToTheLevelSelect() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LevelSelect(themeId)),
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: SafeArea(
        child: GameWidget(
          game: MainMenuGame(goToTheLevelSelect, cnt),
        ),
      ),
    );
  }
}

class MainMenuGame extends Forge2DGame with HasDraggableComponents {
  Function goToTheLevelSelect;
  int cnt;
  @override
  MainMenuGame(this.goToTheLevelSelect, this.cnt)
      : super(gravity: Vector2.all(0.0), zoom: 1.0);

  @override
  Future<void> onLoad() async {
    Vector2 position = screenToWorld(viewport.effectiveSize / 2);
    double radius = 120;
    await super.onLoad();

    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    int numberOfBalls = 30;
    add(DraggableRectThemeButton(position, radius, goToTheLevelSelect, cnt));
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

class DraggableRectThemeButton extends BodyComponent with Draggable {
  Function goToTheLevelSelect;
  Vector2 position;
  double sideOfSquare;
  int cnt;
  DraggableRectThemeButton(
      this.position, this.sideOfSquare, this.goToTheLevelSelect, this.cnt) {
    paint = Paint()..color = Colors.deepPurple.shade600;
  }

  // ignore: empty_constructor_bodies
  @override
  bool onDragEnd(int pointerId, DragEndInfo details) {
    goToTheLevelSelect();
    return true;
  }

  @override
  void renderPolygon(Canvas canvas, List<Offset> points) {
    super.renderPolygon(canvas, points);
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: "$cnt / 20",
      style: TextStyle(
        color: Colors.teal.shade200,
        fontSize: 20,
        // fontFamily: icon.fontFamily,
      ),
    );

    textPainter.layout();
    final lineRotation = Offset(-textPainter.width / 2 + position.x,
        -textPainter.height / 2 + position.y);
    textPainter.paint(canvas, lineRotation);
  }

  @override
  Body createBody() {
    final shape = PolygonShape();
    shape.setAsBox(sideOfSquare, sideOfSquare, position, 0.0);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.5
      ..density = 0.01
      ..friction = 0.0;

    final bodyDef = BodyDef()
      // To be able to determine object in collision
      ..type = BodyType.static;

    Body bodyRet = world.createBody(bodyDef)..createFixture(fixtureDef);
    return bodyRet;
  }
}

// class _ThemeSelectState extends State<ThemeSelect> {
//   final _themes = <String>[];

//   void _buildThemes() {
//     _themes.add('Rectangle');
//   }

//   @override
//   Widget build(BuildContext context) {
//     _buildThemes();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Theme Selection'),
//       ),
//       body: ListView.builder(
//         itemCount: _themes.length * 2 - 1,
//         itemBuilder: (context, i) {
//           if (i.isOdd) {
//             return const Divider();
//           }
//           final index = i ~/ 2;
//           var level_array = context.read<JustWon>();
//           int cnt = 0;
//           for (int i = 0; i < level_array.levels[index].length; i++) {
//             if (level_array.levels[index][i] == true) {
//               cnt = cnt + 1;
//             }
//           }
//           return _buildRow(_themes[index], index, cnt);
//         },
//       ),
//     );
//   }

//   Widget _buildRow(String theme, int themeId, int completed) {
//     return ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LevelSelect(themeId)),
//         );
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(theme + ' - '),
//           Text(completed.toString() + '/20'),
//         ],
//       ),
//     );
//   }
// }
