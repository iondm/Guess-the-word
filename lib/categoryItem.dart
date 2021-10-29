import "package:flutter/material.dart";
import "quiz.dart";

class CategiryItem extends StatelessWidget {
  final String title;
  final String code;
  final Color color;

  CategiryItem(this.title, this.color, this.code);

  void selectCategory(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/categories",
      arguments: code,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      splashColor: Colors.red,
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                spreadRadius: 5,
                offset: Offset(0, 3),
                blurRadius: 7,
                color: Colors.grey.withOpacity(0.5))
          ],
        ),
      ),
    );
  }
}
