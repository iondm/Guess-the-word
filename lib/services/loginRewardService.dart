import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofia/components/game/answerDialogBox.dart';

class LoginRewardService {
  static showloginRewardIfAvaible(
      SharedPreferences prefs, BuildContext context) {
    String? ldt = prefs.getString("lastRewardDate");
    if (ldt == null)
      return prefs.setString("lastRewardDate", DateTime.now().toString());
    DateTime date = DateTime.parse(ldt);
    DateTime now = DateTime.now();
    print(date);
    print(now);

    int difference = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;

    print(difference);

    if (difference < 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            "Daily reward!",
            "You have received 20 coins for the daily log :) ",
            "OK",
            () {
              Navigator.pop(context, true);
            },
            false,
            "assets/images/money.png",
          );
        },
      );
      int? coins = prefs.getInt('points');
      prefs.setString("lastRewardDate", DateTime.now().toString());
      if (coins != null) prefs.setInt('points', coins + 20);
    }
  }
}
