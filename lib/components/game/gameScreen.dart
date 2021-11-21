import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofia/components/game/aswerTextInput.dart';
import 'package:sofia/components/game/dialogBox.dart';
import 'package:sofia/database/levelDB.dart';
import 'package:sofia/database/wordDataDB.dart';
import 'package:sofia/models/wordData.dart';
import 'package:sofia/services/authService.dart';
import '../../models/word.dart';
import '../../models/level.dart';
import 'dart:math' as math;
import '../../database/wordDB.dart';
import '../../queries/levelManager.dart';
import 'answerDialogBox.dart';
import 'package:path/path.dart';
import 'package:audioplayers/audioplayers.dart';

class GameScreen extends StatefulWidget {
  final Level level;
  final List<Word> words;
  int wordIndex;
  int imageIndex;
  final int imagesLength;
  String imagePath;
  final String baseImagePath;

  GameScreen(this.level, this.words, this.wordIndex, this.imageIndex,
      this.imagesLength, this.imagePath, this.baseImagePath);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late final prefs;
  final _controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  int secretTaps = 0, wordIndex = 0, imageIndex = 0, timePassed = 0;
  String responseText = "",
      imagePath = "",
      hint = "",
      baseImgPath = "",
      wordTyped = "",
      userAnswer = "";
  late DateTime timeEnteredWord;
  List<String> wordlemmas = [];
  Color responseColor = Colors.white;
  Container? image;
  bool responseVisibility = false,
      answerResult = false,
      leftArrow = false,
      rightArrow = false,
      isWordSkipped = false;
  AppLifecycleState? _state;
  final player = AudioCache();
  late bool isMusicOn = true;

  AppLifecycleState get state => _state!;

  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    this.baseImgPath = widget.baseImagePath;
    // String wd = "";
    // for (var word in widget.words) {
    //   print(word.lemma);
    //   print(word.lemmas);
    //   wd +=
    //       "new Word.data( synsetId: '${word.synsetId}', levelId: '${word.levelId}', lemma: '${word.lemma}',),";
    // }
    // print(wd);
    this.wordIndex = widget.wordIndex;
    this.imagePath = widget.imagePath;
    this.imageIndex = widget.imageIndex;
    this.wordlemmas = widget.words[this.wordIndex].lemmas.split(";");

    asyncInit();
    checkArrows();

    image = Container(
      child: widget.level.type == "offline"
          ? Image.asset(this.imagePath)
          : Image.file(
              File(join(baseImgPath, this.imagePath)),
            ),
    );
    super.initState();
  }

  void asyncInit() async {
    prefs = await SharedPreferences.getInstance();
    this.isMusicOn = prefs.getBool("isMusicOn");
    initWordData();
    print("timePassed = $timePassed");
    print("DATA Points = ${prefs.getInt('points')} ");
  }

  @override
  void dispose() {
    pauseWordData();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _updateTimer() {
    print("timePassed = $timePassed");
    final duration = DateTime.now().difference(timeEnteredWord);
    timeEnteredWord = DateTime.now();
    this.timePassed += duration.inSeconds;
    prefs.setInt("wordTimer", timePassed);
  }

  void initWordData() {
    isWordSkipped = false;
    timeEnteredWord = DateTime.now();
    int? timePassed = prefs.getInt("wordTimer");
    if (timePassed != null) this.timePassed = timePassed;
    String? wordTyped = prefs.getString("wordTyped");
    if (wordTyped != null) this.wordTyped = wordTyped;
  }

  void pauseWordData() {
    _updateTimer();
    prefs.setString("wordTyped", wordTyped);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        initWordData();
        print('Resumed');
        break;
      case AppLifecycleState.inactive:
        pauseWordData();
        print('Inactive');
        break;
      case AppLifecycleState.paused:
        _updateTimer();
        pauseWordData();
        print('Paused');
        break;
      case AppLifecycleState.detached:
        pauseWordData();
        _updateTimer();
        print('Detached');
        break;
    }
  }

  bool equalsIgnoreCase(String string1, String string2) {
    string1 = string1.replaceAll(" ", "");
    string2 = string2.replaceAll(" ", "");
    return string1.toLowerCase() == string2.toLowerCase();
  }

  void _secretTap() {
    if (secretTaps == 99) {
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
    _updateTimer();
    prefs.setInt("wordTimer", 0);
    prefs.setString("wordTyped", "");
    String userId = (prefs.getString("token") != null)
        ? prefs.getString("userId")
        : prefs.getString("tempUserId");
    Word currentWord = widget.words[this.wordIndex];
    WordData wd = WordData(
        currentWord.synsetId,
        currentWord.levelId,
        userId,
        this.imagePath,
        timePassed,
        wordTyped,
        userAnswer,
        isWordSkipped,
        DateTime.now().toIso8601String());
    wd.printData();
    wd.save();

    WordDataDB.sendToServer(wd);
    userAnswer = "";
    timePassed = 0;
    wordTyped = "";
    isWordSkipped = false;
    hint = "";
    secretTaps = 0;

    this.wordIndex += 1;
    this.imageIndex = 1;
    // print("$wordIndex ${widget.words.length}");

    if (wordIndex == widget.words.length) {
      print("Setting true nextLevel");
      // MODIFY LOCAL DB
      print("setting ${widget.level.id} to complete");
      await LevelDB.setCompleted(widget.level, "true");
      await prefs.setBool('nextLevel', true);

      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              "Congratulations!",
              "You have completed this level!",
              "Next level",
              () {
                Navigator.pop(context, true);
              },
              false,
              "assets/images/medal.png",
            );
          }).then((value) => Navigator.pop(this.context, true));
      AuthService.updateDataToServer();

      return;
    }
    this.wordlemmas = widget.words[this.wordIndex].lemmas.split(";");

    // String wordPath = await widget.words[this.wordIndex].getWordPath();
    // print(wordPath);
    // Directory wordDir = Directory(wordPath);
    // List<FileSystemEntity> images = wordDir.listSync();
    // print(images);
    // this.imagePath = images[0].path.toString();
    prefs.setInt(
        '${widget.words[this.wordIndex].levelId}-last-word', this.wordIndex);
    prefs.setString('lastWord', this.wordIndex.toString());

    prefs.setInt(
        '${widget.words[this.wordIndex].levelId}-${widget.words[this.wordIndex].synsetId}-last-image',
        this.imageIndex);

    this.imagePath = this
        .imagePath
        .replaceFirst(widget.words[this.wordIndex - 1].synsetId,
            widget.words[this.wordIndex].synsetId)
        .replaceFirst(widget.words[this.wordIndex - 1].lemma,
            widget.words[this.wordIndex].lemma);

    setState(() {
      print("words =  ${widget.words.length}");
      image = Container(
        key: ValueKey<int>(this.imageIndex),
        child: widget.level.type == "offline"
            ? Image.asset(this.imagePath)
            : Image.file(
                File(join(baseImgPath, this.imagePath)),
              ),
      );
    });
    checkArrows();
    AuthService.updateDataToServer();
  }

  void checkArrows() {
    print("checkArrows");
    print(widget.imagesLength);
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
    prefs.setInt(
        '${widget.words[this.wordIndex].levelId}-${widget.words[this.wordIndex].synsetId}-last-image',
        this.imageIndex);

    this.imagePath = this.imagePath.substring(0, this.imagePath.length - 5) +
        this.imageIndex.toString() +
        ".jpg";
    setState(() {
      image = Container(
        key: ValueKey<int>(this.imageIndex),
        child: widget.level.type == "offline"
            ? Image.asset(this.imagePath)
            : Image.file(
                File(join(baseImgPath, this.imagePath)),
              ),
      );
      checkArrows();
    });
  }

  void _questionNextWord() async {
    void tempQuestWord() {
      if (this.isMusicOn) player.play('correct.mp3');
      isWordSkipped = true;
      prefs.setInt('points', prefs.getInt('points') - 15);
      _nextWord();
    }

    int coins = prefs.getInt('points');
    if (coins < 15) {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return DialogBox(
                "Skip word",
                "You have $coins coins :( \n It takes 15 to change words. \n \n Guess a word, or enter the game another day to get coins!",
                "Back",
                () {},
                "OK!",
                () {});
          });
    } else {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return DialogBox(
                "Skip word",
                "You have $coins coins, do you want to use 15 to change word?",
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
          context: this.context,
          builder: (BuildContext context) {
            return DialogBox(
                "Hint",
                "You have $coins coins :( \n It takes 5 to get a hint. \n  \n Enter the game another day to get coins!",
                "Back",
                () {},
                "OK!",
                () {});
          });
    } else {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return DialogBox(
                "Hint",
                "You have $coins coins, do you want to use 5 to get a hint?",
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
    bool isGoodAnswer = false;
    // print("testResponse ${widget.words[this.wordIndex].lemma}");
    // print(this.wordlemmas);

    if (equalsIgnoreCase(response,
            widget.words[this.wordIndex].lemma.replaceAll("_", " ")) ==
        true) isGoodAnswer = true;
    wordTyped += response + ";";
    if (!isGoodAnswer)
      for (String lm in this.wordlemmas) {
        if (equalsIgnoreCase(response, lm.replaceAll("_", " ")) == true)
          isGoodAnswer = true;
      }

    if (isGoodAnswer == true) {
      if (this.isMusicOn) player.play('correct.mp3');
      print("mmmmmmmmmm $response");
      this.userAnswer = response;
      hint = "";
      prefs.setInt('points', prefs.getInt('points') + 10);
      // print("${wordIndex + 1}  ${widget.words.length}");

      if ((wordIndex < widget.words.length))
        showDialog(
            context: this.context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                "Correct :)",
                "Congratulation! \n You have earned 10 coins.",
                "Next Word",
                _nextWord,
                true,
                "assets/images/correct-symbol.png",
              );
            });
      else
        _nextWord();
    } else {
      if (this.isMusicOn) player.play('wrong.mp3');
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
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.bottom,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.indigo[400]!,
                Colors.red,
              ],
            )),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    height: 275,
                    child: GestureDetector(
                      child: AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) =>
                                ScaleTransition(child: child, scale: animation),
                        child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.indigo[400]!,
                                  Colors.red,
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: image),
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
                              SizedBox(width: 40),
                              Text(
                                "Skip word 10",
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: AnswerTextInput(
                              _controller,
                              testResponse,
                              responseVisibility,
                              hint,
                              this.focusNode,
                              questionAnswerHint),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              testResponse(_controller.text);
                            },
                            iconSize: 30,
                            icon: Image.asset(
                              "assets/images/game-play.png",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
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
