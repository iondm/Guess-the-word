import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sofia/components/game/gameImage.dart';
import 'package:sofia/components/game/gameScreen.dart';
import 'package:sofia/components/startPage/startPage.dart';
import 'package:sofia/components/level/constants.dart';
import 'package:sofia/database/levelDB.dart';
import 'database/wordDB.dart';
import "quiz.dart";
import 'categoeriesScreen.dart';
import 'Test/imagesTest.dart';
import 'components/level/levels.dart';
import 'database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
  initDb();
  asyncInit();
}

void initDb() async {
  DatabaseHelper? db = DatabaseHelper.instance;
  db.onCreate();
}

void asyncInit() async {
  var prefs = await SharedPreferences.getInstance();

  // prefs.setInt('start_v1-last-word', 0);

  var currentLevel = prefs.getInt('currentLevel');
  if (currentLevel == null) prefs.setInt('currentLevel', 0);

  var points = prefs.getInt('points');
  if (points == null) prefs.setInt('points', 30);
}

class MyApp extends StatelessWidget {
  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 1), //default is 4s
    );
    // Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // This widget is the root of your application.
  void selectCategory(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/game",
      // arguments: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        hintColor: Colors.orange,
      ),
      home: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          child: StartPage(), //ImagesDWtest(),
          //Categories(),
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
        ),
      ),
      routes: {
        "/categories": (ctx) => Quiz(),
        "/game": (ctx) => GameImage(),
      },
    );
  }
}
