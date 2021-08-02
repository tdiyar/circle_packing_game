import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'forge2dWidgets/myGameApp.dart';

import '/commonFiles/ScreenArguments.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Named routes demo', initialRoute: '/', routes: {
      '/': (context) => const MainMenu(),
      '/ThemeSelect': (context) => const ThemeSelect(),
      '/LevelSelect': (context) => const LevelSelect(),
      '/Game': (context) => MyGameApp(),
    });
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
              Navigator.pushNamed(context, '/ThemeSelect');
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
          return _buildRow(_themes[index]);
        },
      ),
    );
  }

  Widget _buildRow(String theme) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/LevelSelect');
      },
      child: Text(theme),
    );
  }
}

class LevelSelect extends StatefulWidget {
  const LevelSelect({Key? key}) : super(key: key);

  @override
  _LevelSelectState createState() => _LevelSelectState();
}

class _LevelSelectState extends State<LevelSelect> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Selection'),
      ),
      body: ListView.builder(
        itemCount: 39,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider();
          }
          final index = i ~/ 2;
          return _buildRow(index);
        },
      ),
    );
  }

  Widget _buildRow(int _levelNumber) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/Game',
            arguments: ScreenArguments(0, _levelNumber));
      },
      child: Text('$_levelNumber'),
    );
  }
}
