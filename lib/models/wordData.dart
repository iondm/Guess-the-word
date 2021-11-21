import '../database/wordDataDB.dart';

class WordData {
  late String lastImage,
      writtenWords,
      answer,
      synsetId,
      levelId,
      userId,
      completedAt;
  late int esecutionTime;
  late bool skipped;

  WordData(
      this.synsetId,
      this.levelId,
      this.userId,
      this.lastImage,
      this.esecutionTime,
      this.writtenWords,
      this.answer,
      this.skipped,
      this.completedAt);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "synset_id": synsetId,
      "level_id": levelId,
      "user_id": userId,
      "last_image": lastImage,
      "written_words": writtenWords,
      "esecution_time": esecutionTime,
      "user_answer": answer,
      "is_skipped": skipped == true ? 1 : 0,
      "completed_at": completedAt,
      "is_in_server": 0
    };
  }

  WordData.fromMap(Map<dynamic, dynamic> map) {
    this.levelId = map["level_id"];
    this.synsetId = map["synset_id"];
    this.userId = map["user_id"];
    this.writtenWords = map["written_words"];
    this.lastImage = map["last_image"];
    this.esecutionTime = map["esecution_time"];
    this.answer = map["user_answer"];
    this.skipped = map["is_skipped"] == 0 ? false : true;
    this.completedAt = map["completed_at"];
  }

  void save() {
    WordDataDB.insert(this);
  }

  void printData() {
    print("synsetId : $synsetId ");
    print("levelId : $levelId ");
    print("userId : $userId ");
    print("lastImage : $lastImage ");
    print("esecutionTime : $esecutionTime ");
    print("writtenWords : $writtenWords ");
    print("answer : $answer ");
    print("skipped : $skipped ");
    print("completedAt : $completedAt ");
  }
}
