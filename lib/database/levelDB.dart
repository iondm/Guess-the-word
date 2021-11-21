import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofia/database/databaseHelper.dart';
import 'package:sofia/database/wordDB.dart';
import 'package:sofia/database/wordDataDB.dart';
import 'package:sofia/models/word.dart';
import 'package:sofia/services/downloadService.dart';
import 'package:sqflite/sqflite.dart';
import '../models/level.dart';
import "dart:convert";
import 'package:http/http.dart' as http;

class LevelDB {
  static void createTable() async {
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return;
    await db.execute('''
              CREATE TABLE IF NOT EXISTS levels (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                completed TEXT,
                type TEXT,
                imagePath TEXT
              )
              ''');
  }

  static Future<int> insert(Level level) async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!.insert("levels", level.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return id;
  }

  static Future<int> setCompleted(Level level, String completed) async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!.update("levels", {"completed": completed},
        where: "id = ?", whereArgs: [level.id]);
    return id;
  }

  static Future<int> deleteLevels() async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!.delete("levels");
    return id;
  }

  static Future<int> delete(Level level) async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!.delete("levels", where: "id = ?", whereArgs: [level.id]);
    return id;
  }

  static Future<List<Level>> getAllLevels() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map> levels = await db!.query(
      "levels",
      columns: ["id", "name", "completed", "type", "imagePath"],
    );
    return List.of(levels.map((e) => Level.fromMap(e)));
  }

  static Future<void> drop() async {
    Database? db = await DatabaseHelper.instance.database;
    await db!.execute("drop table if exists levels");
  }

  static Future<List<Level>?> getServerLevels() async {
    var url = "http://35.180.201.46:8080/levels/getAllLevels";

    final response =
        await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body).map<Level>((e) {
        return Level.fromMap(e);
      }).toList());
    }

    return null;
  }

  static Future<List<Level>?> aCaso() async {
    Database? db = await DatabaseHelper.instance.database;
  }

  static Future<void> remoAllCompleted() async {
    Database? db = await DatabaseHelper.instance.database;
    await db!.update(
      "levels",
      {"completed": "false"},
    );
  }

  static Future<void> removeTempData() async {
    var prefs = await SharedPreferences.getInstance();

    List<Level> levels = await getAllLevels();
    levels.forEach((e) => prefs.setInt('${e.id}-last-word', 0));
  }

  static Future<String> initNewLoginData(int untill) async {
    try {
      var prefs = await SharedPreferences.getInstance();

      Database? db = await DatabaseHelper.instance.database;

      List<Level>? levels = await LevelDB.getServerLevels();

      int? currentLevel = prefs.getInt('currentLevel');
      print("current ====$currentLevel");
      int? lastLevel = prefs.getInt('lastLevelDownloaded');
      print("initNewLoginData $untill");
      levels?.forEach((level) async {
        print("initNewLoginData ${level.type}, ${level.num}");

        if ((level.num! - 1) == untill) {
          prefs.setInt(
              '${level.id}-last-word', int.parse(prefs.getString('lastWord')!));
          print("lastWord = ${prefs.getString('lastWord')}");
          print("${level.id}-last-word");
        }

        if (level.num != null) if (level.type == "online" &&
            level.num! <= untill) {
          await DownloadService.downloadLevelIcon(level.name, level.imagePath);
          await LevelDB.insert(level);
          await setCompleted(level, "true");
        }
        if (level.type == "offline") await setCompleted(level, "true");
        print("end");
      });
      print("$lastLevel");

      print("qui");

      while (lastLevel! <= 10 || currentLevel! + 3 < lastLevel) {
        try {
          print(lastLevel);
          List<Word> words = await WordDB.getFutureWordsFromServer(lastLevel);
          if (words.length == 0) break;

          levels?.forEach((level) async {
            if (level.type == "online" && level.id == words[0].levelId) {
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
          lastLevel += 1;
          prefs.setInt("lastLevelDownloaded", lastLevel);
        } catch (error) {
          print("QUI");
          print(error);
          break;
        }
      }

      await db!.update(
        "levels",
        {"completed": "false"},
      );
      return "ok";
    } catch (e) {
      print(e);
      return "error";
    }
  }

  static void getLevelsFromServer() async {
    var prefs = await SharedPreferences.getInstance();

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
              print("downloading");

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
  }
}
