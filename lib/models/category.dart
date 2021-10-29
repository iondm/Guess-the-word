import "package:flutter/material.dart";

class Category {
  final String id;
  final String name;
  final Color color;
  final String code;

  const Category(
      {required this.id,
      required this.name,
      this.color = Colors.orange,
      this.code = "artists"});
}
