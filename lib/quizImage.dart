import 'dart:async';

import "package:flutter/material.dart";

class QuizImage extends StatefulWidget {
  String imgLink;
  Function nextImage;
  Function newImage;

  bool imageDisplayed = false;

  QuizImage(this.imgLink, this.nextImage, this.newImage);

  @override
  _State createState() => _State();
}

class _State extends State<QuizImage> {
  bool imageDisplayed = false;

  void checkImage() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      if (imageDisplayed == false) {
        // widget.nextImage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 275,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: (widget.imgLink != "")
                  ? Image.network(
                      widget.imgLink,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        if (error.toString() ==
                            "type 'Null' is not a subtype of type 'List<int>' in type cast")
                          return Center(
                              child: CircularProgressIndicator(value: 0.1));
                        print("START ERROR");
                        print(error.toString());

                        print(error.toString() ==
                            "Exception: Invalid image data");
                        print("LINK: " + widget.imgLink);

                        Future.delayed(Duration(seconds: 2)).then((_) {
                          print("try again");
                          widget.nextImage();
                        });

                        print("END ERROR");

                        return Center(
                            child: CircularProgressIndicator(value: 0.1));
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        checkImage();

                        return Center(
                          // child: Image.asset("assets/images/loading-opaque.gif")
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    )
                  : Container(),
            ),
          ),
          // OutlineButton(
          //   onPressed: () => widget.nextImage(),
          //   child: Text("Change image2"),
          // ),
        ],
      ),
    );
  }
}
