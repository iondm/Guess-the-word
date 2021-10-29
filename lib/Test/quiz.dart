import "dart:convert";
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:sofia/quizImage.dart';

class Quiz extends StatefulWidget {
  // final String imgType;

  // Quiz(this.imgType);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final _controller = TextEditingController();

  String word = "";
  String imgPath = "";
  List images = [];
  int imageIndex = 0;
  bool answerResult = false;
  String imgType = "";
  int secretTaps = 0;
  bool secretWordVisibility = false;
  bool responseVisibility = false;
  late BuildContext ctx;
  String responseText = "";
  Color responseColor = Colors.white;

  bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }

  void fetchImage(String type) {
    if (type == "start" && imgPath != "") return;
    if (type == "start" && imgPath == "") {
      Future.delayed(Duration(seconds: 3)).then((_) {
        fetchImage("normal");
      });
      return;
    }
    // ignore: unnecessary_statements

    secretWordVisibility = false;
    secretTaps = 0;

    // print("Funziono:" + _controller.text);

    print("_____Start request");

    http
        .get(Uri.parse(
            'https://nodejs-sofia-be.herokuapp.com/getRandomImage?imgType=' +
                this.imgType))
        .timeout(
      Duration(seconds: 10),
      onTimeout: () {
        return http.Response('Error', 500); // Replace 500 with your http code.
      },
    ).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        this.word = result['word'];
        this.images = result["images"];
        this.answerResult = false;
        this.imageIndex = 0;

        setState(() {
          _controller.clear();
          this.imgPath = images[imageIndex]['url'];
        });
        print(this.imgType + " - " + this.word + " - " + this.imgPath);
      } else
        fetchImage("normal"); // Rep
    });
  }

  void nextImage() {
    // ignore: unnecessary_statements
    _controller.clear;
    print("total: " +
        this.images.length.toString() +
        ", current: " +
        this.imageIndex.toString() +
        ", check: " +
        (this.imageIndex + 1).toString());
    if (this.images.length > this.imageIndex + 1) {
      this.imageIndex = this.imageIndex + 1;
      if (!(this.images[imageIndex]['url'].endsWith(".jpg") ||
          this.images[imageIndex]['url'].endsWith(".JPG") ||
          this.images[imageIndex]['url'].endsWith(".png") ||
          this.images[imageIndex]['url'].endsWith(".PNG"))) {
        print("skip: " + this.images[imageIndex]['url']);
        nextImage();
      } else {
        setState(() {
          this.imgPath = this.images[imageIndex]['url'];
          print(this.imgPath);
        });
      }
    } else {
      fetchImage("normal");
    }
  }

  void secretTap() {
    if (secretTaps == 5) {
      // print(secretTaps.toString());
      setState(() {
        responseVisibility = true; // second function
        responseText = this.word; // second function
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

  void testResponse(String response) {
    if (equalsIgnoreCase(response, this.word) == true) {
      setState(() {
        responseVisibility = true; // second function
        responseText = "Good Answer!"; // second function
        responseColor = Colors.green;
      });

      Future.delayed(Duration(seconds: 3)).then((_) {
        setState(() {
          responseVisibility = false; // second function
        });
        fetchImage("normal");
      });
    } else {
      setState(() {
        responseVisibility = true; // second function
        responseText = "Try again!"; // second function
        responseColor = Colors.red;
      });

      Future.delayed(Duration(seconds: 3)).then((_) {
        setState(() {
          responseVisibility = false; // second function
        });
      });

      this.answerResult = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.ctx = context;
    this.imgType = ModalRoute.of(context)!.settings.arguments as String;
    fetchImage("start");
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
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
                GestureDetector(
                  child: QuizImage(imgPath, nextImage, fetchImage),
                  onTap: secretTap,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    onSubmitted: testResponse,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Try to guess",
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => fetchImage("normal"),
                      child: Text("Change word"),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                      onPressed: nextImage,
                      child: Text("Change image"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: Visibility(
                      child: Text(
                        responseText,
                        style: TextStyle(color: responseColor, fontSize: 20),
                      ),
                      visible: responseVisibility,
                    )),
                  ],
                ),
                // FloatingActionButton(onPressed: Naviga)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
