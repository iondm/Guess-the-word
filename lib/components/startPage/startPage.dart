import "package:flutter/material.dart";
import 'package:sofia/components/credits/credits.dart';
import 'package:sofia/components/level/levels.dart';
import 'package:sofia/database/levelDB.dart';
import 'package:sofia/database/wordDB.dart';
import 'package:sofia/models/level.dart';
import 'package:sofia/models/word.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late List<Level> levels = [];

  @override
  void initState() {
    super.initState();
    initLevels();
  }

  initLevels() async {
    print("I should print cose");
    List<Word> words = await WordDB.getWords("vehicle_v1", null);
    print("NUM : ${words.length}");

    words.forEach((e) {
      int c = 1;
      while (c < 5) {
        print("   - assets/levels/${e.synsetId}/img_${e.lemma}$c.jpg\n");
        c += 1;
      }
      print("");
    });

    var appLevels = await LevelDB.getAllLevels();
    while (appLevels.length < 3) {
      print("Tryt again");

      await Future.delayed(Duration(seconds: 1));
      appLevels = await LevelDB.getAllLevels();
    }

    setState(() {
      this.levels = appLevels;
    });
    print("LEVELS LOADED:");
    this.levels.forEach((element) {
      print(element.name);
    });
    print("");

    try {
      _getLevelsFromServer();
    } catch (e) {
      print("Server not responding");
    }
  }

  void goToLevels() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Levels(this.levels);
        },
      ),
    );
  }

  void goToCredits() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Credits();
        },
      ),
    );
  }

  void _getLevelsFromServer() async {
    print("Looking for levels server");

    List<Level>? levels = await LevelDB.getServerLevels();
    // if (levels == null) {
    //   _moveToError(context);
    //   return;
    // }

    levels?.forEach((level) {
      if (level.type == "online") {
        print("Isert ${level.id}");
        // LevelDB.insert(level);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200.0),
                        child: Image.asset(
                          'assets/logo-white.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: IconButton(
                    onPressed: this.levels.length >= 3 ? goToLevels : () {},
                    icon: Image.asset(
                      "assets/images/play-button.png",
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),
                  ],
                ),
                SizedBox(),
                SizedBox(),
                SizedBox(),
                SizedBox(),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      "Credits",
                    ),
                    onPressed: () {
                      goToCredits();
                    },
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
