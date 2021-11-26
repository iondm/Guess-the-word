import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofia/components/auth_screen.dart';
import 'package:sofia/components/credits/credits.dart';
import 'package:sofia/components/level/levels.dart';
import 'package:sofia/database/levelDB.dart';
import 'package:sofia/database/wordDB.dart';
import 'package:sofia/database/wordDataDB.dart';
import 'package:sofia/models/level.dart';
import 'package:sofia/models/word.dart';
import 'package:sofia/services/authService.dart';
import 'package:sofia/services/downloadService.dart';
import 'package:sofia/services/loginRewardService.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  late List<Level> levels = [];
  late AnimationController controller;
  late SharedPreferences prefs;
  bool isAllLoaded = false, checkReward = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);

    try {
      initLevels();
      WordDataDB.updateServerData();
    } catch (e) {
      print(e);
    }

    super.initState();
  }

  Future<void> loadPrefs() async {
    this.prefs = await SharedPreferences.getInstance();
    if (checkReward == false) {
      checkReward = true;
      LoginRewardService.showloginRewardIfAvaible(prefs, this.context);
    }
  }

  uploadUserDataToServer() async {}

  initLevels() async {
    await Future.delayed(Duration(seconds: 1));
    await loadPrefs();

    _getLevelsFromServer();
    // print("I should print cose");
    // List<Word> words = await WordDB.getWords("vehicle_v1", null);
    // print("NUM : ${words.ength}");

    // words.forEach((e) {
    //   int c = 1;
    //   while (c < 5) {
    //     print("   - assets/levels/${e.synsetId}/img_${e.lemma}$c.jpg\n");
    //     c += 1;
    //   }
    //   print("");
    // });
    // var appLevels = List<Level>

    bool? isDBCreated = this.prefs.getBool("isDBCreated");
    int c = 0;
    while (isDBCreated == null || c == 10) {
      c += 1;
      print("Tryt again");
      isDBCreated = this.prefs.getBool("isDBCreated");
      await Future.delayed(Duration(seconds: 1));
      await loadPrefs();
    }
    try {
      var appLevels = await LevelDB.getAllLevels();
      setState(() {
        isAllLoaded = true;
        this.levels = appLevels;
      });
    } catch (e) {
      print(e);
    }
    if (!this.isAuth) AuthService.updateDataToServer();

    // print("LEVELS LOADED:");
    // this.levels.forEach((element) {
    //   print(element.name);
    //   print(element.imagePath);
    // });
    // print("");
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

  bool get isAuth {
    String? expTime = prefs.getString("tokenExpire");
    if (expTime != null) if (DateTime.parse(expTime).isBefore(DateTime.now())) {
      //return false TODO REF TOKEN
    }

    // print("\t token: ${prefs.getString("token")}");
    return prefs.getString("token") == null;
  }

  String? get token {
    String? stringTime = prefs.getString("tokenExpire");
    String? token = prefs.getString("token");

    if (stringTime == null) return null;
    DateTime expiryDate = DateTime.parse(stringTime);

    if (expiryDate.isAfter(DateTime.now()) && token != null) return token;
    return null;
  }

  void goToAuth() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return AuthScreen();
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

  void logout() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Logout"),
              content: Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                TextButton(
                  child: Text("Yes", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    prefs.remove("token");
                    prefs.remove("localId");
                    prefs.remove("tokenExpire");
                    prefs.setInt("currentLevel", 0);
                    WordDataDB.deleteAll();
                    LevelDB.remoAllCompleted();
                    LevelDB.removeTempData();

                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ));
  }

  void _getLevelsFromServer() async {
    print("Looking for levels in server");

    try {
      List<Level>? levels = await LevelDB.getServerLevels();

      int? currentLevel = prefs.getInt('currentLevel');
      int? lastLevel = prefs.getInt('lastLevelDownloaded');
      if (currentLevel == null) return;
      print("lastLevel= $lastLevel, currentLevel=$currentLevel ");
      while (lastLevel! <= 13 || currentLevel + 3 < lastLevel) {
        print("try to download");
        try {
          List<Word> words = await WordDB.getFutureWordsFromServer(lastLevel);
          if (words.length == 0) return;

          levels?.forEach((level) async {
            if (level.type == "online" && level.id == words[0].levelId) {
              print("\tdownloading icon");

              await DownloadService.downloadLevelIcon(
                  level.name, level.imagePath);
              await LevelDB.insert(level);
            }
          });

          for (Word word in words) {
            for (int x = 1; x <= 4; x += 1) {
              print("downloading $x ${word.lemma}");
              await DownloadService.downloadWordImage(
                  word.levelId, word.synsetId, word.lemma, x.toString());
            }
            await WordDB.insert(word);
          }
          print("INCREMENTO");
          lastLevel += 1;
          prefs.setInt("lastLevelDownloaded", lastLevel);
        } catch (error) {
          print(error);
          break;
        }
      }
    } catch (e) {
      print(e);
    }
    initLevels();
  }

  @override
  Widget build(BuildContext context) {
    loadPrefs();
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
                this.isAllLoaded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: IconButton(
                                onPressed: this.levels.length >= 3
                                    ? goToLevels
                                    : () {},
                                icon: Image.asset(
                                  "assets/images/play-button.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            this.isAuth
                                ? TextButton(
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.orange),
                                    ),
                                    onPressed: goToAuth,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Welcome!",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.orange),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                        onPressed: logout,
                                        icon: Image.asset(
                                          "assets/images/logout.png",
                                        ),
                                      ),
                                    ],
                                  ),
                            // TextButton(
                            //     onPressed: () {
                            //       LevelDB.initNewLoginData(10);
                            //       //AuthService.updateDataToServer();
                            //     },
                            //     child: Text("test"))
                          ])
                    : CircularProgressIndicator(
                        value: controller.value,
                        semanticsLabel: 'Linear progress indicator',
                      ),
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
                      "Credits and info",
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
