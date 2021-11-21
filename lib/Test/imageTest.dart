import 'dart:io';
import 'dart:async';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:path/path.dart';

import 'package:sofia/components/error/http_exception.dart';

class ImageTest extends StatefulWidget {
  @override
  _ImageTestState createState() => _ImageTestState();
}

class _ImageTestState extends State<ImageTest> {
  @override
  void initState() {
    // downloadImage();
    super.initState();
  }

  bool isLoaded = true;
  File file = File(
      "/data/user/0/com.guess_the_word.so/app_flutter/assets/levels/bn:00010217n/img_book1.jpg");

  void downloadImage() async {
    print("Init request");

    Uri url = Uri.parse(
        "http://35.180.201.46:8080/downloadWordImage?levelId=bn:00013077n&fileName=img_bridge1.jpg");
    var response = await http.get(url);
    print(response);
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    this.file = new File(join(documentDirectory.path, 'imagetest.png'));
    file.writeAsBytesSync(
        response.bodyBytes); // This is a sync operation on a real
    // app you'd probably prefer to use writeAsByte and handle its Future

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("TESTING"),
            isLoaded ? Image.file(this.file) : Text("loading"),
          ],
        ),
      ),
    );
  }
}
