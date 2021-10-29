import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofia/components/game/aswerTextInput.dart';
import 'package:sofia/components/game/dialogBox.dart';
import 'package:sofia/database/levelDB.dart';
import '../../models/word.dart';
import '../../models/level.dart';
import 'dart:math' as math;

import '../../database/wordDB.dart';
import '../../queries/levelManager.dart';
import 'answerDialogBox.dart';

class GameScreen extends StatefulWidget {
  final Level level;
  final List<Word> words;
  int wordIndex;
  int imageIndex;
  final int imagesLength;
  String imagePath;

  GameScreen(this.level, this.words, this.wordIndex, this.imageIndex,
      this.imagesLength, this.imagePath);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int secretTaps = 0, wordIndex = 0, imageIndex = 0;
  bool responseVisibility = false,
      answerResult = false,
      leftArrow = false,
      rightArrow = false;
  String responseText = "", imagePath = "", hint = "";
  Color responseColor = Colors.white;
  Container? image;
  final _controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late final prefs;

  void initState() {
    super.initState();
    this.wordIndex = widget.wordIndex;
    this.imagePath = widget.imagePath;
    this.imageIndex = widget.imageIndex;
    asyncInit();
    checkArrows();

    image = Container(
      child: Image.file(
        File(this.imagePath),
      ),
    );
  }

  void asyncInit() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', 20);

    print("DATA Points = ${prefs.getInt('points')} ");
  }

  void manageErrorImage() async {
    if (await LevelManager.checkFile(this.imagePath))
      print("trovato");
    else
      _nextWord();
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }

  void _secretTap() {
    if (secretTaps == 5) {
      // print(secretTaps.toString());
      setState(() {
        responseVisibility = true; // second function
        responseText = widget.words[this.wordIndex].lemma; // second function
        responseColor = Colors.black;
      });

      Future.delayed(Duration(seconds: 3)).then((_) {
        setState(() {
          responseVisibility = false; // second function
        });
      });
    } else
      secretTaps += 1;
  }

  void _nextWord() async {
    hint = "";
    secretTaps = 0;
    print("change state");
    this.wordIndex += 1;
    this.imageIndex = 1;

    String wordPath = await widget.words[this.wordIndex].getWordPath();
    print(wordPath);
    Directory wordDir = Directory(wordPath);
    List<FileSystemEntity> images = wordDir.listSync();
    print(images);
    this.imagePath = images[0].path.toString();

    setState(() {
      print("words =  ${widget.words.length}");
      image = Container(
        key: ValueKey<int>(this.imageIndex),
        child: Image.file(
          File(this.imagePath),
        ),
      );
    });
    checkArrows();
  }

  void checkArrows() {
    print(this.imageIndex);
    setState(() {
      if (this.imageIndex == 0 || this.imageIndex == 1) {
        leftArrow = false;
        if (this.imageIndex == widget.imagesLength)
          rightArrow = false;
        else
          rightArrow = true;
      } else if (this.imageIndex == widget.imagesLength) {
        if (this.imageIndex == 0 || this.imageIndex == 1)
          leftArrow = false;
        else
          leftArrow = true;
        rightArrow = false;
      } else {
        leftArrow = true;
        rightArrow = true;
      }
    });
  }

  void _nextImage(int pos) {
    if (this.imageIndex + pos > widget.imagesLength ||
        this.imageIndex + pos <= 0) {
      return;
    }
    if (this.imageIndex == 0) this.imageIndex += 1;
    this.imageIndex += pos;
    print("${this.imageIndex} + " " + ${widget.imagesLength}");

    setState(() {
      image = Container(
        height: 275,
        key: ValueKey<int>(this.imageIndex),
        child: Image.file(
          File(this.imagePath.substring(0, this.imagePath.length - 5) +
              this.imageIndex.toString() +
              ".jpg"),
        ),
      );
      checkArrows();

      print(this.imagePath);
    });
  }

  void _questionNextWord() async {
    void tempQuestWord() {
      prefs.setInt('points', prefs.getInt('points') - 10);
      _nextWord();
    }

    int coins = prefs.getInt('points');
    if (coins < 10) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogBox(
                "Skip word",
                "You have $coins coins :( \n It takes 10 to change words  \n Guess a word, or enter the game another day to get coins!",
                "Back",
                () {},
                "OK!",
                () {});
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogBox(
                "Skip word",
                "You have $coins coins, do you want to use 10 to change words?.",
                "Cancel",
                () {},
                "Yes",
                tempQuestWord);
          });
    }
  }

  void questionAnswerHint() async {
    int coins = prefs.getInt('points');
    if (coins < 5) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogBox(
                "Hint",
                "You have $coins coins :( \n It takes 5 to have a hint.  \n Enter the game another day to get coins!",
                "Back",
                () {},
                "OK!",
                () {});
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogBox(
                "Hint",
                "You have $coins coins, do you want to use 5 to get a hint?.",
                "Cancel",
                () {},
                "Yes",
                _giveHint);
          });
    }
  }

  _giveHint() {
    prefs.setInt('points', prefs.getInt('points') - 5);
    int lenght = widget.words[this.wordIndex].lemma.length;
    hint = " The word has $lenght letters";
    focusNode.requestFocus();
  }

  void testResponse(String response) {
    print("testResponse ${widget.words[this.wordIndex].lemma}");
    if (equalsIgnoreCase(response, widget.words[this.wordIndex].lemma) ==
        true) {
      hint = "";
      prefs.setInt('points', prefs.getInt('points') + 10);
      print("DATA Points = ${prefs.getInt('points')} ");

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
                "Correct :)",
                "Congratulation! \n You have earned 10 coins.",
                "Next Word",
                _nextWord);
          });
    } else {
      setState(() {
        hint = "Try again!";
        responseVisibility = true; // second function
        responseText = "Try again!"; // second function
        responseColor = Colors.red;
      });

      Future.delayed(Duration(seconds: 3)).then((_) {
        setState(() {
          responseVisibility = false; // second function
        });
      });
      focusNode.requestFocus();
      this.answerResult = false;
    }
    _controller.clear();
  }

  void _removeWord() {
    WordDB.delete(widget.words[this.wordIndex]);
    _nextWord();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.9), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    height: 275,
                    child: GestureDetector(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 2000),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              child: child, opacity: animation);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: image,
                        ),
                      ),
                      onTap: _secretTap,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () => _nextImage(-1),
                          icon: Transform.rotate(
                              angle: 90 * math.pi / 180,
                              child: Icon(
                                Icons.arrow_circle_down_sharp,
                                size: 40,
                                color: leftArrow == true
                                    ? Colors.teal
                                    : Colors.black,
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextButton(
                          onPressed: () => _questionNextWord(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 28),
                              Text(
                                "Skip word 10",
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 16),
                              ),
                              SizedBox(width: 8),
                              Image.asset("assets/images/coins.png", height: 20)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () => _nextImage(1),
                          iconSize: 30,
                          icon: Transform.rotate(
                              angle: 90 * math.pi / 180,
                              child: Icon(
                                Icons.arrow_circle_up_sharp,
                                size: 40,
                                color: rightArrow == true
                                    ? Colors.teal
                                    : Colors.black,
                              )),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: AnswerTextInput(
                        _controller,
                        testResponse,
                        responseVisibility,
                        hint,
                        this.focusNode,
                        questionAnswerHint),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Visibility(
                          child: Text(
                            responseText,
                            style:
                                TextStyle(color: responseColor, fontSize: 20),
                          ),
                          visible: responseVisibility,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
