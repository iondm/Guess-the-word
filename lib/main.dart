import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sofia/Test/imageTest.dart';
import 'package:sofia/components/auth_screen.dart';
import 'package:sofia/components/game/gameImage.dart';
import 'package:sofia/components/startPage/startPage.dart';
import 'package:sofia/services/authService.dart';
import 'package:sofia/services/loginRewardService.dart';
import 'database/databaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));

  asyncInit();
}

Future<void> initDb(SharedPreferences prefs) async {
  DatabaseHelper? db = DatabaseHelper.instance;
  var dbVersion = prefs.getString('dbVersion');

  if (dbVersion != "1.0.6") {
    prefs.clear();
    await db.deleteDB();
    prefs.setInt('currentLevel', 0);
    prefs.setInt('points', 30);
    prefs.setInt('start_v1-last-word', 0);
    prefs.setInt('sport_v1-last-word', 0);
    prefs.setInt('monument_v1-last-word', 0);
    prefs.setInt('animal_v1-last-word', 0);
    prefs.setInt('vehicle_v1-last-word', 0);
  }
  prefs.setString('dbVersion', "1.0.6");

  await db.onCreate();
  print("DB CREATED");
}

void asyncInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var prefs = await SharedPreferences.getInstance();
  await initDb(prefs);

  // prefs.setInt('start_v1-last-word', 0);

  if (prefs.getBool('isMusicOn') == null) prefs.setInt('currentLevel', 0);
  if (prefs.getBool('isMusicOn') == null) prefs.setBool('isMusicOn', true);
  if (prefs.getInt('lastLevelDownloaded') == null)
    prefs.setInt('lastLevelDownloaded', 6);
  if (prefs.getInt('points') == null) prefs.setInt('points', 40);
  prefs.setString('lastWord', "null");
  if (prefs.getString('tempUserId') == null)
    prefs.setString('tempUserId', Uuid().v4());
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
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AuthService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          hintColor: Colors.black,
        ),
        home: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Container(
            child: StartPage(),
            // StartPage(), //ImagesDWtest(),
            //Categories(),
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
          ),
        ),
        routes: {
          "/game": (ctx) => GameImage(),
          "/auth": (ctx) => AuthScreen(),
        },
      ),
    );
  }
}
