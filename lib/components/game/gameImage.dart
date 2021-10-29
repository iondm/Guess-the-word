import "package:flutter/material.dart";

class GameImage extends StatefulWidget {
  @override
  _GameImageState createState() => _GameImageState();
}

class _GameImageState extends State<GameImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(body: TextField()));
  }
}
