import 'dart:io';

import '../database/wordDB.dart';
import 'package:path_provider/path_provider.dart';

class Word {
  late String synsetId;
  late String levelId;
  late String lemma;
  late int completed = 0;
  late int imageNumbers = 4;
  late String lemmas = "null";

  Word();
  Word.data({
    this.synsetId: "synsetId",
    this.levelId: "levelId",
    this.lemma: "lemma",
    this.lemmas: "null",
  });

  Word.fromMap(Map<dynamic, dynamic> map) {
    synsetId = map["synset_id"];
    levelId = map["level_id"];
    lemma = map["lemma"];
    completed = map["completed"];
    imageNumbers = map["image_numbers"];
    lemmas = map["lemmas"] != null ? map["lemmas"] : "null";
  }

  Word.fromServerMap(Map<dynamic, dynamic> map) {
    synsetId = map["synsetId"];
    levelId = map["levelId"];
    lemma = map["lemma"];
    completed = int.parse(map["completed"]);
    imageNumbers = int.parse(map["imageNumbers"]);
    lemmas = map["lemmas"] != null ? map["lemmas"] : "null";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "synset_id": synsetId,
      "level_id": levelId,
      "lemma": lemma,
      "completed": completed,
      "image_numbers": imageNumbers,
      "lemmas": lemmas,
    };
  }

  void save() {
    WordDB.insert(this);
  }

  Future<int> getImgsLengths() async {
    String basepath = (await getApplicationDocumentsDirectory()).path;

    List file = Directory(
            "$basepath/levels/${this.levelId}/${this.synsetId.replaceFirst(":", "_")}") //downloads/") 5d12528c-1234-4554-bcec-1589432af321"
        .listSync(); //use your folder name insted of resume.

    return file.length;
  }

  Future<String> getWordPath() async {
    String basepath = (await getApplicationDocumentsDirectory()).path;
    return "$basepath/levels/${this.levelId}/${this.synsetId.replaceFirst(":", "_")}";
  }
}
