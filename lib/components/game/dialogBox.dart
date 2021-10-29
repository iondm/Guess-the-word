import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofia/components/game/constants.dart';

class DialogBox extends StatefulWidget {
  final String title, descriptions, textLeft, textRight;
  final Function actionRight, actionLeft;

  const DialogBox(this.title, this.descriptions, this.textLeft, this.actionLeft,
      this.textRight, this.actionRight);

  @override
  _DialogBox createState() => _DialogBox();
}

class _DialogBox extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.padding, //Constants.avatarRadius +
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    "assets/images/coins.png",
                    height: 30,
                    width: 30,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          widget.actionLeft();
                          Navigator.of(context).pop();
                        },
                        child: Text(widget.textLeft,
                            style:
                                TextStyle(color: Colors.black, fontSize: 18))),
                    TextButton(
                        onPressed: () {
                          widget.actionRight();
                          Navigator.of(context).pop();
                        },
                        child: Text(widget.textRight,
                            style:
                                TextStyle(color: Colors.black, fontSize: 18))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
