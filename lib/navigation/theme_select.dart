import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'level_select.dart';
import '../main.dart';

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
