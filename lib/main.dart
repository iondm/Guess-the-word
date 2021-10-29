import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sofia/components/game/gameImage.dart';
import 'package:sofia/components/game/gameScreen.dart';
import "quiz.dart";
import 'categoeriesScreen.dart';
import 'Test/imagesTest.dart';
import 'components/level/levels.dart';
import 'database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
  initDb();
}

void initDb() async {
  DatabaseHelper? db = DatabaseHelper.instance;
  db.onCreate();
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
        primarySwatch: Colors.green,
        hintColor: Colors.green,
      ),
      home: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          child: Levels(), //ImagesDWtest(),
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
