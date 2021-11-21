import 'package:sofia/database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/wordData.dart';
import "dart:convert";
import 'package:http/http.dart' as http;

class WordDataDB {
  static void createTable() async {
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return;
    await db.execute('''
              CREATE TABLE IF NOT EXISTS wordData (
                level_id varchar(255) not null,
                synset_id varchar(255) not null,
                user_id varchar(255) not null,
                last_image varchar(255),
                esecution_time integer,
                written_words varchar(1000),
                user_answer varchar(255),
                is_skipped integer,
                completed_at varchar(255),
                is_in_server integer,

                primary key (level_id, synset_id, user_id),
                foreign key (level_id) references levels(id),
                foreign key (synset_id) references words(synset_id) 
            );
              ''');
  }

  static Future<int> insert(WordData worddata) async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!.insert("wordData", worddata.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<void> sendToServer(WordData wd) async {
    print("sending ${wd.synsetId} and ${wd.levelId} to server");
    var url = "http://35.180.201.46:8080/setUserWordData?" +
        "synsetId=${wd.synsetId}" +
        "&userId=${wd.userId}" +
        "&levelId=${wd.levelId}" +
        "&lastImage=${wd.lastImage}" +
        "&esecutionTime=${wd.esecutionTime}" +
        "&writtenWords=${wd.writtenWords}" +
        "&answer=${wd.answer}" +
        "&skipped=${wd.skipped}" +
        "&completedAt=${wd.completedAt}";
    print(url);

    final response =
        await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
    print("response = $response");
    if (response.statusCode == 200) {
      if (response.body == "ok") {
        setWordDataUploded(wd.synsetId, wd.levelId);
      }
    }
  }

  static Future<void> setWordDataUploded(
      String synsetId, String levelId) async {
    Database? db = await DatabaseHelper.instance.database;
    await db!.update("wordData", {"is_in_server": 1},
        where: "synset_id = ? and level_id = ?",
        whereArgs: [synsetId, levelId]);
  }

  static Future<List<WordData>> getWordDataList() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map> words = await db!.query("wordData",
        columns: [
          "level_id",
          "synset_id",
          "user_id",
          "last_image",
          "esecution_time",
          "written_words",
          "user_answer",
          "is_skipped",
          "completed_at"
        ],
        where: "is_in_server = 0");
    return List.of(words.map((e) => WordData.fromMap(e)));
  }

  static Future<void> drop() async {
    Database? db = await DatabaseHelper.instance.database;
    await db!.execute("drop table if exists wordData");
  }

  static Future<int> deleteAll() async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!.delete("wordData");
    return id;
  }

  static void updateServerData() async {
    List<WordData> words = await getWordDataList();
    for (WordData word in words) {
      print("__________");
      word.printData();
      try {
        sendToServer(word);
      } catch (e) {
        print(e);
        break;
      }
    }
  }
}
