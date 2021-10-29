import "package:flutter/material.dart";
import 'categoriesData.dart';
import 'categoryItem.dart';
import 'package:rainbow_color/rainbow_color.dart';

// categoriesList
class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color> _colorAnim;

  @override
  void initState() {
    super.initState();
    this.controller =
        AnimationController(duration: Duration(seconds: 15), vsync: this);
    this._colorAnim = RainbowColorTween([
      Colors.black,
      Colors.red.shade800,
      Colors.orange.shade800,
      Colors.green.shade500,
      Colors.blue.shade700,
      Colors.black,
    ]).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.9), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 100,
                  child: Text("Select a category!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.black))),
              Center(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return CategiryItem(
                        categoriesList[index].name,
                        categoriesList[index].color,
                        categoriesList[index].code,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                          height: 20,
                        ),
                    itemCount: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
