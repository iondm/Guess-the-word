import '../database/levelDB.dart';

class Level {
  late String id;
  late String name;
  late String type;
  late String imagePath;
  late int? num;
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
    imagePath = map["icon_path"] == null
        ? map["imagePath"] == null
            ? ""
            : map["imagePath"]
        : map["icon_path"];

    if (map["num"] != null) {
      num = int.parse(map["num"]);
    }
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
