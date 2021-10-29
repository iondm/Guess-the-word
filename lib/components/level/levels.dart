import "package:flutter/material.dart";
import 'package:sofia/components/game/loadingScreen.dart';
import 'package:sofia/database/wordDB.dart';
import 'dart:io';
import 'package:sofia/models/level.dart';
import 'package:sofia/database/levelDB.dart';
import 'package:sofia/models/word.dart';
import 'package:sofia/queries/levelManager.dart';
import 'package:sofia/quiz.dart';
import '../game/gameScreen.dart';
import '../error/error.dart';

class Levels extends StatefulWidget {
  @override
  _LevelsState createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  List<Level>? levels;

  initState() {
    super.initState();

    _getLevelsFromServer();
    _checkLocalData();
  }

  _checkLocalData() async {
    print("Looking for levels internal");
    List<Level> levels = await LevelDB.getAllLevels();
    // No levels locally so start a server request.
    if (levels.length > 0) {
      setState(() {
        this.levels = levels;
      });
    }
  }

  void _moveToError(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Error();
        },
      ),
    );
  }

  void _getLevelsFromServer() async {
    print("Looking for levels server");

    levels = await LevelDB.getServerLevels();
    // if (levels == null) {
    //   _moveToError(context);
    //   return;
    // }
    print(levels);

    levels?.forEach((level) {
      LevelDB.insert(level);
    });
  }

  void _moveToGame(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoadingScreen(levels![index]);
        },
      ),
    );
  }

  void _test() {
    LevelManager.printFileInDIr("dirPath");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Container(
              height: 100,
              child: Text(
                "Select a category!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.black),
              ),
            ),
            Container(
              child: levels != null
                  ? SizedBox(
                      height: 400,
                      child: Center(
                        child: ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return ElevatedButton(
                                  onPressed: () => _moveToGame(context, index),
                                  child: Text(levels![index].name));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 4),
                            itemCount: levels!.length),
                      ),
                    )
                  : Center(
                      child: Image.network(
                          "https://cdn.dribbble.com/users/1186261/screenshots/3718681/media/27438516469ad4d494718cb2b9895ca5.gif"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
