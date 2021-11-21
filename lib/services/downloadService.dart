import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:path/path.dart';

class DownloadService {
  static Future<void> downloadWordImage(
      String levelId, String synsetId, String lemma, String imageIndex) async {
    String imgPath = "assets/levels/$synsetId/img_$lemma$imageIndex.jpg";
    Uri url = Uri.parse(
        "http://35.180.201.46:8080/downloadWordImage?levelId=$synsetId&fileName=img_$lemma$imageIndex.jpg");
    var response = await http.get(url);
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = new File(join(documentDirectory.path, imgPath));
    await file.create(recursive: true);

    if (!(await file.exists())) print("file not exist");

    await file
        .writeAsBytes(response.bodyBytes); // This is a sync operation on a real
    // app you'd probably prefer to use writeAsByte and handle its Future
    if (await file.exists()) print("file exist");
  }

  static Future<void> downloadLevelIcon(
      String levelName, String imgPath) async {
    print(imgPath.split("/")[2]);
    Uri url = Uri.parse(
        "http://35.180.201.46:8080/downloadIcon/${imgPath.split('/')[2]}");
    print(url.toString());
    var response = await http.get(url);
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = new File(join(documentDirectory.path, imgPath));
    if (!(await file.exists())) print("file not exist");
    await file.create(recursive: true);
    file.writeAsBytesSync(
      response.bodyBytes,
    );

    Future.delayed(Duration(seconds: 3)).then((_) async {
      if (await file.exists()) print("file exist");
    });
  }
}
