import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../forge2dWidgets/myGameApp.dart';
import 'package:provider/provider.dart';

import '/commonFiles/ScreenArguments.dart';
import '../main.dart';

class LevelSelect extends StatefulWidget {
  final int themeId;
  const LevelSelect(this.themeId);

  @override
  _LevelSelectState createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level Selection'),
      ),
      body: ListView.builder(
        itemCount: 39,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider();
          }
          final index = i ~/ 2;
          return _buildRow(index + 1);
        },
      ),
    );
  }

  Widget _buildRow(int _levelNumber) {
    var color = Colors.blue;
    var level_array = context.read<JustWon>();
    print(level_array);
    if (level_array.levels[0][_levelNumber - 1] == true) {
      color = Colors.orange;
    }

    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyGameApp(),
            settings:
                RouteSettings(arguments: ScreenArguments(0, _levelNumber)),
          ),
        );
      },
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
      child: Text('$_levelNumber'),
    );
  }
}
