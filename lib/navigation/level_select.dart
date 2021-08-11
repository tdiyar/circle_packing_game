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

/*
width: 428.0
height: 926.0
*/

class _LevelSelectState extends State<LevelSelect> {
  @override
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    return Scaffold(
      backgroundColor: Colors.black,
      /*appBar: AppBar(
        title: Text('Level Selection'),
      ),*/
      body: ListView.builder(
        padding: EdgeInsets.only(top: height / 11.575),
        itemCount: 11,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider(
              height: height / 13.2285714286,
            );
          }
          final index = i ~/ 2;
          //return _buildRow(index + 1);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRow(index * 3 + 1, width, height),
              _buildRow(index * 3 + 2, width, height),
              _buildRow(index * 3 + 3, width, height),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRow(int _levelNumber, double screenWidth, double screenHeight) {
    var color = Color(0xFF5E35B1);
    var levelArray = context.read<JustWon>();
    print(levelArray);
    if (levelArray.levels[0][_levelNumber - 1] == true) {
      color = Color(0xFF80CBC4);
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
        height: screenHeight / 13.2285714286,
        width: screenWidth / 6.11428571429,
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
