import '../database/levelDB.dart';

class Level {
  late String id;
  late String name;

  Level();

  Level.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    name = map["name"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"id": id, "name": name};
  }
}
