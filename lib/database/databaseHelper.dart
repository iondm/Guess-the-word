import 'dart:io';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofia/components/level/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/level.dart';
import 'levelDB.dart';
import 'wordDB.dart';
import 'wordDataDB.dart';

// database table and column names
final String tableWords = 'words';
final String columnId = '_id';
final String columnWord = 'word';
final String columnFrequency = 'frequency';

// singleton class to manage the database
class DatabaseHelper {
  static final _databaseName = "Sofia.db";
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    {
      await _initDatabase();
    }
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    _database = await openDatabase(path, version: _databaseVersion);
  }

  Future<void> onCreate() async {
    LevelDB.createTable();
    WordDB.createTable();
    WordDataDB.createTable();

    await initDbData();
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDBCreated", true);
    print("Set isDBCreated to true");
  }

  Future deleteDB() async {
    await LevelDB.drop();
    await WordDB.drop();
    await WordDataDB.drop();
  }

  Future<void> initDbData() async {
    final levelsDB = await LevelDB.getAllLevels();

    if (levelsDB.length == 0) {
      print("Init DB");

      final levels = Constants.levels;
      for (final level in levels) {
        level.save();
        print("SAVE level ${level.id}");
        print("initDbData level ${level.imagePath}");

        final words = await WordDB.getWords(level.id, null);

        if (words.length == 0) {
          Constants.getLevelWords(level.id).forEach((word) {
            // print(
            //     "Saving in level ${word.levelId} lemma ${word.lemma} id ${word.synsetId}  lemmas ${word.lemmas}   ");
            word.save();
          });
        }
      }
    }
  }
}
