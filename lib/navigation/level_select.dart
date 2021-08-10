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
      /*appBar: AppBar(
        title: Text('Level Selection'),
      ),*/
      body: ListView.builder(
        padding: EdgeInsets.all(80),
        itemCount: 11,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider(
              height: 70,
            );
          }
          final index = i ~/ 2;
          //return _buildRow(index + 1);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRow(index * 3 + 1),
              _buildRow(index * 3 + 2),
              _buildRow(index * 3 + 3),
            ],
          );
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

    /*return FloatingActionButton.extended(
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
      backgroundColor: color,
      label: Text('$_levelNumber'),
    );*/

    return SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton.extended(
          heroTag: '$_levelNumber',
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
          backgroundColor: color,
          label: Text('$_levelNumber'),
        ));
  }
}
