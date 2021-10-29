import "package:flutter/material.dart";
import 'package:sofia/components/game/gameImage.dart';
import 'package:sofia/database/wordDB.dart';
import 'package:sofia/models/level.dart';
import 'package:sofia/models/word.dart';
import 'package:sofia/queries/levelManager.dart';

import 'gameScreen.dart';
import 'dart:io';

class LoadingScreen extends StatefulWidget {
  final Level level;
  LoadingScreen(this.level);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<Word> words = [];
  int wordIndex = 0;
  int imageIndex = 0;
  int imagesLength = 0;
  String imagePath = "";
  int maxImgDownload = 11;
  int indexImgDownload = 0;

  initState() {
    super.initState();

    _loadAndMoveToWords(context);
  }

  _loadAndMoveToWords(BuildContext context) async {
    // Chech if local data is present.
    this.words = await WordDB.getWords(widget.level.id, null);

    // If not present load data from server.
    if (this.words.length == 0) {
      print("Word not presents in local db");
      _downloadLevelDataAndStartGame(context);
    } else {
      print("Word presents in local db");
      await _elaboratePathData();
      // TODO CHECK IF INTERNET IS AVAIBLE FOR DOWNLOAD
      if (this.imagePath == "noImages") {
        await _downloadImages(false);
        await Future.delayed(Duration(seconds: 10));
      }
      await _elaboratePathData();

      print("end _loadAndMoveToWords");

      _moveToGame(context);
    }
  }

  _elaboratePathData() async {
    try {
      String wordPath = await this.words[this.wordIndex].getWordPath();
      // print(wordPath);
      Directory wordDir = Directory(wordPath);
      List<FileSystemEntity> images = wordDir.listSync();
      // print(images);
      this.imagePath = images[imageIndex].path.toString();
      this.imagesLength = images.length;
    } catch (e) {
      print(e);
      this.imagePath = "noImages";
    }
  }

  _downloadImages(bool save) async {
    print("start _downloadImages ");
    try {
      words.forEach((word) {
        if (this.maxImgDownload > this.indexImgDownload) {
          this.indexImgDownload += 1;
          LevelManager.downloadStoreAndDeleteWord(word.synsetId, word.levelId);
        }
      });

      // for (Word word in words) {
      //   // Download from server.
      //   print("start ${word.lemma}");
      //   await LevelManager.downloadStoreAndDeleteWord(
      //       word.synsetId, word.levelId);
      //   // Save in local db.
      //   if (save) word.save();
      //   print("finish ${word.lemma}");
      // }
    } catch (e) {
      print("caych error downloading");

      print(e);
    }
    print("finish downloading");
  }

  _downloadLevelDataAndStartGame(BuildContext context) async {
    this.words =
        await WordDB.getWordsFromServer(widget.level.id, "test_id", null);
    print(words);

    // If words are present save in localdb and start game.
    if (this.words.length > 0) {
      words.forEach((word) {
        print(
            "Saving in level ${word.levelId} lemma ${word.lemma} id ${word.synsetId}");
        word.save();
      });
      await _elaboratePathData();

      if (this.imagePath == "noImages") {
        await _downloadImages(true);
      }
      print("Moving to game");

      _moveToGame(context);
    } else {
      print("SERVER ERROR");
      // MAKE SERVER ERROR SOMETHING.
    }
  }

  void selectCategory(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/game",
      // arguments: code,
    );
  }

  void _moveToGame(BuildContext context) async {
    if (widget.level.name == "animals") {
      this.wordIndex = 1;
      _elaboratePathData();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return GameScreen(widget.level, words, wordIndex, imageIndex,
              imagesLength, imagePath);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // _loadAndMoveToWords(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.network(
              "https://cdn.dribbble.com/users/1186261/screenshots/3718681/media/27438516469ad4d494718cb2b9895ca5.gif"),
        ),
      ),
    );
  }
}
