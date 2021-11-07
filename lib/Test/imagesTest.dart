// import "package:flutter/material.dart";
// import 'package:http/http.dart' as http;
// import "dart:convert";
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_archive/flutter_archive.dart';
// // import 'package:permission_handler/permission_handler.dart';
// import '../queries/levelManager.dart';

// class ImagesDWtest extends StatefulWidget {
//   @override
//   _ImagesDWtestState createState() => _ImagesDWtestState();
// }

// class _ImagesDWtestState extends State<ImagesDWtest> {
//   late PermissionStatus _permissionStatus;

//   initState() {
//     super.initState();
//     _loginDirPrint();
//     _startTestFunctions();

//     // Get storage permission.
//     () async {
//       _permissionStatus = await Permission.storage.status;

//       if (_permissionStatus != PermissionStatus.granted) {
//         PermissionStatus permissionStatus = await Permission.storage.request();
//         setState(() {
//           _permissionStatus = permissionStatus;
//         });
//       }
//     }();
//   }

//   void _loginDirPrint() async {
//     LevelManager.printFileInDIr(
//         "levels/5d12528c-1234-4554-bcec-1589432af321/bn_00002870n");

//     // LevelManager.printFileInDIr(
//     //     "downloads/5d12528c-1234-4554-bcec-1589432af321");
//   }

//   void removeFiles() async {
//     String BasePath = "/data/user/0/com.example.sofia/app_flutter/";
//     LevelManager.removeDirectory(
//         "/data/user/0/com.example.sofia/app_flutter/downloads/levelId");
//   }

//   void _startTestFunctions() async {
//     // LevelManager.printFileInDIr(
//     //     "downloads/5d12528c-1234-4554-bcec-1589432af321");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Center(
//           child: Column(
//             children: [
//               ElevatedButton(
//                 onPressed: () => print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"),
//                 child: Text("Change image"),
//               ),
//               ElevatedButton(
//                 onPressed: () => _loginDirPrint(),
//                 child: Text("_loginDirPrint"),
//               ),
//               ElevatedButton(
//                 onPressed: () => LevelManager.unzipWordFile(
//                     "bn_00002870n", "5d12528c-1234-4554-bcec-1589432af321"),
//                 child: Text("unzipfile"),
//               ),
//               ElevatedButton(
//                 onPressed: () => removeFiles(),
//                 child: Text("removeFiles"),
//               ),
//               ElevatedButton(
//                 onPressed: () => LevelManager.getMissingLevels(
//                     "5d12528c-1234-4554-bcec-1589432af321"),
//                 child: Text("getMissingLevels"),
//               ),
//               ElevatedButton(
//                 onPressed: () => LevelManager.getAndStoreMissingLevelWordImage(
//                     "5d12528c-1234-4554-bcec-1589432af321"),
//                 child: Text("getAndStoreMissingLevelWord"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
