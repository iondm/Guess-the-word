import '../database/levelDB.dart';

class Level {
  late String id;
  late String name;
  late String type;
  late String imagePath;
  bool completed = false;

  Level();

  Level.data(
      {this.id: "id",
      this.name: "name",
      this.type: "type",
      this.imagePath: "imagePath"});

  Level.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    name = map["name"];
    completed = map["completed"] == "true" ? true : false;
    type = map["type"] == null ? "" : map["type"];
    imagePath = map["imagePath"] == null ? "" : map["imagePath"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "completed": completed ? "true" : "false",
      "type": type,
      "imagePath": imagePath
    };
  }

  void save() {
    LevelDB.insert(this);
  }
}
