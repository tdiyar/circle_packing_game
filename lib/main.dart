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

void SaveFile(String content) async {
  File file = File(await getFilePath());
  file.writeAsString(content);
}

void init(BuildContext context) async {
  File file = File(await getFilePath());
  if (file.exists() == false) {
    return;
  }
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
