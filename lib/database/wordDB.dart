import 'package:sofia/database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/word.dart';
import "dart:convert";
import 'package:http/http.dart' as http;

class WordDB {
  static void createTable() async {
    Database? db = await DatabaseHelper.instance.database;
    if (db == null) return;
    await db.execute('''
              CREATE TABLE IF NOT EXISTS words (
                synset_id varchar(255) primary key,
                level_id varchar(255) not null,
                lemma varchar(255),
                completed integer,
                image_numbers integer
            );
              ''');
  }

  static Future<int> insert(Word word) async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!.insert("words", word.toMap());
    return id;
  }

  static Future<int> deleteAll() async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!.delete("words");
    return id;
  }

  static Future<int> delete(Word word) async {
    Database? db = await DatabaseHelper.instance.database;
    int id = await db!
        .delete("words", where: "synset_id = ?", whereArgs: [word.synsetId]);
    return id;
  }

  static Future<void> drop() async {
    Database? db = await DatabaseHelper.instance.database;
    await db!.execute("drop table if exists words");
  }

  static Future<List<Word>> getWords(String levelId, bool? completed) async {
    String comp = "";
    if (completed != null) {
      comp = (completed == true) ? 'completed = true' : "completed = false";
    }

    Database? db = await DatabaseHelper.instance.database;
    List<Map> words = await db!.query(
      "words",
      columns: ["synset_id", "level_id", "lemma", "completed", "image_numbers"],
      where: "level_id = ? ${(completed != null) ? " and " + comp : ""}",
      whereArgs: [levelId],
    );
    return List.of(words.map((e) => Word.fromMap(e)));
  }

  static Future<List<Word>> getWordsFromServer(
      String levelId, String token, bool? completed) async {
    print("get Words From Server");

    String isCompreted = "";
    if (completed != null) {
      isCompreted =
          (completed == true) ? "&completed=True" : "&completed=False";
    }

    var url =
        "http://35.180.201.46:8080/words?levelId=" + levelId + isCompreted;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "token": token,
      },
    );
    if (response.statusCode == 200) {
      return (jsonDecode(response.body).map<Word>((e) {
        return Word.fromServerMap(e);
      }).toList());
    } else
      throw Exception('Something went wrong');
  }
}
