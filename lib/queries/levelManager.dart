import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_archive/flutter_archive.dart';
// import 'package:permission_handler/permission_handler.dart';

class LevelManager {
  static void printFileInDIr(String dirPath) async {
    String directory = (await getApplicationDocumentsDirectory()).path;
    print("$directory/$dirPath");
    List file = Directory(
            "$directory/$dirPath") //downloads/") 5d12528c-1234-4554-bcec-1589432af321"
        .listSync(); //use your folder name insted of resume.

    file.forEach((element) {
      print(element);
      // element.delete();
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print("DWNCB " + status.toString() + progress.toString());
  }

  static void removeFile(String filePath) async {
    try {
      File(filePath).delete();
    } catch (e) {
      print(e);
    }
  }

  static void removeDirectory(String filePath) async {
    try {
      Directory(filePath).delete(recursive: true);
    } catch (e) {
      print(e);
    }
  }

  static void findFile(String filename) async {
    String filePath =
        (await getApplicationDocumentsDirectory()).path + '/downloads/';

    print(await File(filePath + filename).exists());
  }

  static Future<bool> checkFile(String filename) async {
    String filePath =
        (await getApplicationDocumentsDirectory()).path + '/downloads/';

    return (await File(filePath + filename).exists());
  }

  static Future<void> unzipWordFile(String filename, String levelId) async {
    print("\tStart unzip");
    String basepath = (await getApplicationDocumentsDirectory()).path;
    String levelPath = "$basepath/levels";

    filename = filename.replaceFirst(":", "_");

    // Create the dir if not exist
    Directory levelsDir = Directory(levelPath);
    if (!(await levelsDir.exists())) {
      levelsDir.create();
    }
    Directory levelDir = Directory("$levelPath/$levelId/");
    if (!(await levelDir.exists())) {
      levelDir.create();
    }
    Directory destinationDir = Directory("$levelPath/$levelId/$filename/");
    if (!(await destinationDir.exists())) {
      await destinationDir.create();
    }
    print("try do unzip at: $levelPath/$levelId/$filename/");

    final zipFile = File("storage/emulated/0/Download/$filename.zip");
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile, destinationDir: destinationDir);
    } catch (e) {
      print(e);
    }
    zipFile.delete();
    print("Unzipped and deleted: " + filename);
  }

  static Future<List<dynamic>> getMissingLevels(String levelId) async {
    var url =
        "http://35.180.201.46:8080/getMissingWordFromLevel?levelId=" + levelId;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "token": 'test_id',
      },
    );
    if (response.statusCode == 200)
      return jsonDecode(response.body);
    else
      throw Exception('Something went wrong');
  }

  static void getAndStoreMissingLevelWordImage(String levelId) async {
    List<dynamic> words;
    try {
      words = await getMissingLevels(levelId);
    } catch (e) {
      print(e);
      return;
    }

    words.forEach((wordId) => downloadStoreAndDeleteWord(wordId, levelId));
  }

  static Future<void> downloadStoreAndDeleteWord(
      String wordId, String levelId) async {
    await getFile(wordId, ".zip");
    print("done get FIle");
    await Future.delayed(Duration(seconds: 4));
    print("start unzip");

    await unzipWordFile(wordId, levelId);
  }

  static Future<void> getFile(String fileName, String fileExtension) async {
    print("\tstart get file");
    // WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: false // optional: set false to disable printing logs to console
        );

    String filePath =
        (await getApplicationDocumentsDirectory()).path + '/downloads/';

    // Create the dir if not exist
    final savedDir = Directory(filePath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    var myUrl =
        "http://35.180.201.46:8080/downloadFile/" + fileName + fileExtension;

    print("Start download");
    print(myUrl);

    FlutterDownloader.registerCallback(downloadCallback);

    await FlutterDownloader.enqueue(
      url: myUrl,
      savedDir: filePath,
      showNotification:
          false, // show download progress in status bar (for Android)
      openFileFromNotification:
          false, // click on notification to open downloaded file (for Android)
    );
    print("End download");

    // FlutterDownloader.registerCallback(downloadCallback);
  }
}
