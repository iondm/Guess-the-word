import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofia/components/game/answerDialogBox.dart';
import 'package:sofia/components/game/loadingScreen.dart';
import 'package:sofia/database/levelDB.dart';
import 'package:sofia/database/wordDB.dart';
import 'dart:io';
import 'package:sofia/models/level.dart';
import 'package:sofia/models/word.dart';
import 'package:sofia/queries/levelManager.dart';
import '../game/gameScreen.dart';
import 'dart:math' as math;
import 'package:flutter/animation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:path/path.dart';

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
  ItemScrollController _scrollController = ItemScrollController();
  String baseIconLevelPath = "";
  bool isMusicOn = true;

  initState() {
    print("initlevels");
    super.initState();
    initPrefs();
    this.levels = widget.levels;
    LevelDB.getLevelsFromServer();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController!.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  dispose() {
    _animationController!.dispose(); // you need this
    super.dispose();
  }

  void initPrefs() async {
    this.baseIconLevelPath = (await getApplicationDocumentsDirectory()).path;
    this.prefs = await SharedPreferences.getInstance();
    this.isMusicOn = prefs.getBool('isMusicOn');
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

    setState(() {
      this.currentLevel = newCurrentLevel;
    });

    if (this.currentLevel != widget.levels.length)
      _scrollController.scrollTo(
          index: this.currentLevel, duration: Duration(seconds: 1));
    else {
      _scrollController.scrollTo(
          index: this.currentLevel - 1, duration: Duration(seconds: 1));
      showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            "Congratulations!",
            "You have completed all levels! \nCheck back soon for more content :) ",
            "OK",
            () {
              Navigator.pop(context, true);
            },
            false,
            "assets/images/coming-soon.png",
          );
        },
      );
    }
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
            baseIconLevelPath,
          );
        },
      ),
    );
    if (value) // if true and you have come back to your Settings screen
      checkCurrentLevel();
  }

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
    // if (index == levels.length) {
    //   return Container(
    //     child: Center(
    //       child: IconButton(
    //           onPressed: () => {},
    //           // _moveToGame(context, getIndexLevelFromId(levels[index].id)),
    //           iconSize: 70,
    //           icon: Image.asset("assets/images/coming-soon.png")),
    //     ),
    //   );
    // }
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
                onPressed: () =>
                    _moveToGameOffline(this.context, levels[index]),
                iconSize: 70,
                icon: levels[index].type == "offline"
                    ? Image.asset(levels[index].imagePath)
                    : Image.file(File(
                        join(baseIconLevelPath, levels[index].imagePath)))),
          ),
        ),
      );
    }

    if (index < currentLevel)
      return Container(
        child: Center(
          child: IconButton(
              onPressed: () => {},
              // _moveToGame(context, getIndexLevelFromId(levels[index].id)),
              iconSize: 70,
              icon: levels[index].type == "offline"
                  ? Image.asset(levels[index].imagePath)
                  : Image.file(
                      File(join(baseIconLevelPath, levels[index].imagePath)))),
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
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ScrollablePositionedList.builder(
                    reverse: true,
                    itemScrollController: _scrollController,
                    itemCount: levels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: [
                            index < levels.length - 1
                                ? index % 2 == 0
                                    ? Container(
                                        height: 60,
                                        child: Transform.rotate(
                                            angle: -math.pi / 4,
                                            child: Image.asset(
                                                "assets/images/up-arrow.png")))
                                    : Container(
                                        height: 60,
                                        child: Transform(
                                            alignment: Alignment.center,
                                            transform:
                                                Matrix4.rotationY(math.pi),
                                            child: Transform.rotate(
                                                angle: -math.pi / 4,
                                                child: Image.asset(
                                                    "assets/images/up-arrow.png"))))
                                : SizedBox(),
                            SizedBox(
                              height: 15,
                            ),
                            getLevel(index),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 15,
            top: 10,
            child: Column(
              children: [
                Container(
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
                SizedBox(width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: this.isMusicOn == true
                          ? Icon(
                              Icons.music_note,
                              size: 40,
                              color: Colors.orange,
                            )
                          : Icon(
                              Icons.music_off,
                              size: 40,
                              color: Colors.black,
                            ),
                      onPressed: () {
                        prefs.setBool("isMusicOn", !this.isMusicOn);
                        setState(
                          () {
                            this.isMusicOn = !this.isMusicOn;
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            left: 15,
            top: 10,
            child: IconButton(
              icon: Image.asset("assets/images/left.png"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
