import 'package:sofia/database/databaseHelper.dart';
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
                name TEXT NOT NULL
              )
              ''');
  }

  static Future<int> insert(Level level) async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!.insert("levels", level.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
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
      columns: ["id", "name"],
    );
    return List.of(levels.map((e) => Level.fromMap(e)));
  }

  static Future<List<Level>?> getServerLevels() async {
    var url = "http://35.180.201.46:8080/levels/getAllLevels";
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return (jsonDecode(response.body).map<Level>((e) {
          return Level.fromMap(e);
        }).toList());
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Level>?> aCaso() async {
    Database? db = await DatabaseHelper.instance.database;
  }
}
