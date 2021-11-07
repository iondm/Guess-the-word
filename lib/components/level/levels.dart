import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
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
import 'dart:math' as math;
import 'package:flutter/animation.dart';
import 'package:sofia/components/level/constants.dart';

class Levels extends StatefulWidget {
  final List<Level> levels;

  Levels(this.levels);
  @override
  _LevelsState createState() => _LevelsState();
}

class _LevelsState extends State<Levels> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation _animation;
  late List<Level> levels;
  int currentLevel = 0;
  List<Word> words = [];
  int wordIndex = 0;
  int imageIndex = 0;
  int imagesLength = 0;
  String imagePath = "";
  int maxImgDownload = 1;
  int indexImgDownload = 0;
  int coins = 0;
  late final prefs;

  initState() {
    super.initState();
    initPrefs();
    this.levels = widget.levels;
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController!.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
    // _checkLocalData();
  }

  @override
  dispose() {
    _animationController!.dispose(); // you need this
    super.dispose();
  }

  void initPrefs() async {
    this.prefs = await SharedPreferences.getInstance();
    setState(() {
      this.coins = prefs.getInt('points');
    });
    checkCurrentLevel();
  }

  void checkCurrentLevel() async {
    setState(() {
      this.coins = prefs.getInt('points');
    });

    bool? isNextLevel = prefs.getBool('nextLevel');

    int newCurrentLevel = prefs.getInt('currentLevel');

    if (isNextLevel != null && isNextLevel) {
      levels[newCurrentLevel].completed = true;

      newCurrentLevel += 1;
      prefs.setInt('currentLevel', newCurrentLevel);
      prefs.setBool('nextLevel', false);
    }
    print("setting Game To = $newCurrentLevel");

    setState(() {
      this.currentLevel = newCurrentLevel;
    });
  }

  void _moveToGameOffline(
    BuildContext context,
    Level level,
  ) async {
    final words = await WordDB.getWords(level.id, null);

    final appWordIndex = prefs.getInt('${level.id}-last-word');
    final wordIndex = (appWordIndex != null) ? appWordIndex : 0;
    final appImageIndex =
        prefs.getInt('${level.id}-${words[wordIndex].synsetId}-last-image');
    final imageIndex = (appImageIndex != null) ? appImageIndex : 1;
    final imagePath =
        "assets/levels/${words[wordIndex].synsetId}/img_${words[wordIndex].lemma}$imageIndex.jpg";

    bool value = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return GameScreen(
            level,
            words,
            wordIndex,
            imageIndex,
            4,
            imagePath,
            "offline",
          );
        },
      ),
    );
    if (value) // if true and you have come back to your Settings screen
      checkCurrentLevel();
  }

  // _checkLocalData() async {
  //   print("Looking for levels internal");
  //   List<Level> levels = await LevelDB.getAllLevels();
  //   // No levels locally so start a server request.
  //   print("Local levels:");
  //   print(levels);
  //   if (levels.length > 0) {
  //     setState(() {
  //       this.levels = levels;
  //     });
  //   }
  // }

  // void _moveToError(BuildContext context) async {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (_) {
  //         return Error();
  //       },
  //     ),
  //   );
  // }

  void _moveToGame(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoadingScreen(levels[index]);
        },
      ),
    );
  }

  int getIndexLevelFromId(String levelId) {
    int counter = 0;
    for (Level level in levels) {
      if (level.id == levelId) return counter;
      counter += 1;
    }
    return 0;
  }

  void _test() {
    LevelManager.printFileInDIr("dirPath");
  }

  Container getLevel(int index) {
    if (currentLevel == index) {
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(
              color: Colors.blue[100]!,
              blurRadius: _animation.value,
              spreadRadius: _animation.value)
        ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: IconButton(
                onPressed: () => _moveToGameOffline(context, levels[index]),
                iconSize: 70,
                icon: Image.asset(levels[index].imagePath)),
          ),
        ),
      );
    }

    if (levels[index].completed)
      return Container(
        child: Center(
          child: IconButton(
              onPressed: () => {},
              // _moveToGame(context, getIndexLevelFromId(levels[index].id)),
              iconSize: 70,
              icon: Image.asset(levels[index].imagePath)),
        ),
      );
    else
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 15, spreadRadius: 15)
        ]),
        child: Center(
          child: IconButton(
              onPressed: () => {},
              // _moveToGame(context, getIndexLevelFromId(levels[index].id)),
              iconSize: 70,
              icon: Image.asset("assets/images/unknown.png")),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.bottom,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.indigo[400]!,
                Colors.red,
              ],
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container(
                //   height: 100,
                //   child: Text(
                //     "Select a category!",
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 35,
                //         color: Colors.black),
                //   ),
                // ),
                // Container(
                //   child: levels != null
                //       ? SizedBox(
                //           height: MediaQuery.of(context).size.height - 600,
                //           child: ListView.separated(
                //               shrinkWrap: true,
                //               reverse: true,
                //               itemBuilder: (BuildContext context, int index) {
                //                 return ElevatedButton(
                //                     onPressed: () => _moveToGame(context, index),
                //                     child: Text(levels![index].name));
                //               },
                //               separatorBuilder:
                //                   (BuildContext context, int index) =>
                //                       const SizedBox(height: 4),
                //               itemCount: levels!.length),
                //         )
                //       : Center(
                //           child: Image.network(
                //               "https://cdn.dribbble.com/users/1186261/screenshots/3718681/media/27438516469ad4d494718cb2b9895ca5.gif"),
                //         ),
                // ),
                Expanded(
                  child: ListView.separated(
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: getLevel(index),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Container(
                            height: 60,
                            child: Transform.rotate(
                                angle: -math.pi / 4,
                                child:
                                    Image.asset("assets/images/up-arrow.png"))),
                    itemCount: levels.length,
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       flex: 2,
                //       child: Container(
                //           height: 60,
                //           child: Transform.rotate(
                //               angle: -math.pi / 4,
                //               child: Image.asset("assets/images/up-arrow.png"))),
                //     ),
                //     Expanded(flex: 1, child: SizedBox(width: 10)),
                //     Expanded(
                //       flex: 2,
                //       child: Transform(
                //         alignment: Alignment.center,
                //         transform: Matrix4.rotationY(math.pi),
                //         child: Container(
                //             height: 60,
                //             child: Transform.rotate(
                //                 angle: -math.pi / 4,
                //                 child:
                //                     Image.asset("assets/images/up-arrow.png"))),
                //       ),
                //     ),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(
                //         iconSize: 60,
                //         onPressed: () => _moveToGame(context, 1),
                //         icon: RotatedBox(
                //             quarterTurns: 0,
                //             child: Image.asset("assets/images/turtle.png"))),
                //     SizedBox(width: 100),
                //     IconButton(
                //         iconSize: 60,
                //         onPressed: () => _moveToGame(context, 2),
                //         icon: RotatedBox(
                //             quarterTurns: 0,
                //             child: Image.asset("assets/images/sports.png"))),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(
                //         iconSize: 60,
                //         onPressed: () => {},
                //         icon: RotatedBox(
                //             quarterTurns: 3,
                //             child: Image.asset("assets/images/up-arrow.png"))),
                //     SizedBox(width: 40),
                //     IconButton(
                //         iconSize: 60,
                //         onPressed: () => {},
                //         icon: RotatedBox(
                //             quarterTurns: 0,
                //             child: Image.asset("assets/images/up-arrow.png"))),
                //   ],
                // ),
                // Container(
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Color.fromARGB(255, 27, 28, 30),
                //       boxShadow: [
                //         BoxShadow(
                //             color: Color.fromARGB(130, 237, 125, 58),
                //             blurRadius: _animation.value,
                //             spreadRadius: _animation.value)
                //       ]),
                //   child: Center(
                //     child: IconButton(
                //         onPressed: () =>
                //             _moveToGame(context, getIndexLevelFromId("start_v1")),
                //         iconSize: 50,
                //         icon: Image.asset("assets/images/start.png")),
                //   ),
                // )
              ],
            ),
          ),
          Positioned(
            right: 15,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange[700]!),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Text(
                    "${this.coins}",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(width: 8),
                  Image.asset("assets/images/coins.png", height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
