import "package:flutter/material.dart";

class Error extends StatelessWidget {
  const Error({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.network(
              "https://developers.google.com/maps/documentation/maps-static/images/error-image-generic.png"),
        ),
      ),
    );
  }
}
