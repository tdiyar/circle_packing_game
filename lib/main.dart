import 'package:circle_packing/navigation/main_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

// ignore: non_constant_identifier_names
void SaveFile(String content) async {
  File file = File(await getFilePath());
  file.writeAsString(content);
}

void init(BuildContext context) async {
  File file = File(await getFilePath());
  if (await file.exists() == false) {
    return;
  }
  String fileContent = await file.readAsString();

  var levelArray = context.read<JustWon>();

  for (var i = 0; i < fileContent.length; i++) {
    bool value = fileContent[i] == '1' ? true : false;
    levelArray.update_level(i ~/ 20, i % 20, value);
  }
}

class JustWon with ChangeNotifier {
  static const num_of_levels = 18;
  static const num_of_themes = 1;
  var levels =
      List.generate(num_of_themes, (i) => List.generate(18, (j) => false));

  // ignore: non_constant_identifier_names
  Future<void> update_level(int theme, int lvlNumber, bool value) async {
    levels[theme][lvlNumber] = value;
    String cur = '';

    for (var i = 0; i < 1; i++) {
      for (var j = 0; j < num_of_levels; j++) {
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
