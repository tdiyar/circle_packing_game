import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'forge2dWidgets/myGameApp.dart';
import 'forge2dWidgets/cirle_packing_game.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '/commonFiles/ScreenArguments.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => JustWon(),
    child: MyApp(),
  ));
}

Future<String> getFilePath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;
  String filePath = '$appDocumentsPath/demoTextFile.txt';
  print(filePath);
  return filePath;
}

void SaveFile(String content) async {
  File file = File(await getFilePath());
  file.writeAsString(content);
}

void init(BuildContext context) async {
  File file = File(await getFilePath());
  String fileContent = await file.readAsString();

  var level_array = context.read<JustWon>();

  for (var i = 0; i < fileContent.length; i++) {
    bool value = fileContent[i] == '1' ? true : false;
    level_array.update_level(i ~/ 20, i % 20, value);
  }
}

class JustWon with ChangeNotifier {
  var levels = List.generate(1, (i) => List.generate(20, (j) => false));

  void update_level(int theme, int lvl_number, bool value) {
    levels[theme][lvl_number] = value;
    String cur = '';

    for (var i = 0; i < 1; i++) {
      for (var j = 0; j < 20; j++) {
        cur += levels[i][j] ? '1' : '0';
      }
    }

    SaveFile(cur);

    print(levels);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    init(context);
    return MaterialApp(
      title: 'Circle Packing',
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main menu'),
      ),
      body: Center(
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeSelect()),
              );
            },
            child: Icon(Icons.play_arrow)),
      ),
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Selection'),
      ),
      body: ListView.builder(
        itemCount: _themes.length * 2 - 1,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider();
          }
          final index = i ~/ 2;
          var level_array = context.read<JustWon>();
          int cnt = 0;
          for (int i = 0; i < level_array.levels[index].length; i++) {
            if (level_array.levels[index][i] == true) {
              cnt = cnt + 1;
            }
          }
          return _buildRow(_themes[index], index, cnt);
        },
      ),
    );
  }

  Widget _buildRow(String theme, int themeId, int completed) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LevelSelect(themeId)),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(theme + ' - '),
          Text(completed.toString() + '/20'),
        ],
      ),
    );
  }
}

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
