import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:sofia/models/level.dart';
import 'package:sofia/models/word.dart';

class Constants {
  Constants._();

  static var levels = [
    new Level.data(
      id: "start_v1",
      name: "start",
      type: "offline",
      imagePath: "assets/images/start.png",
    ),
    new Level.data(
      id: "sport_v1",
      name: "sport",
      type: "offline",
      imagePath: "assets/images/sports.png",
    ),
    new Level.data(
      id: "monument_v1",
      name: "monument",
      type: "offline",
      imagePath: "assets/images/monument.png",
    ),
    new Level.data(
      id: "animal_v1",
      name: "animal",
      type: "offline",
      imagePath: "assets/images/turtle.png",
    ),
    new Level.data(
      id: "vehicle_v1",
      name: "vehicle",
      type: "offline",
      imagePath: "assets/images/vehicle.png",
    )
  ];

  static final vehicle_v1 = [
    new Word.data(
      synsetId: 'bn:00007309n',
      levelId: 'vehicle_v1',
      lemma: 'car',
    ),
    new Word.data(
      synsetId: 'bn:00077857n',
      levelId: 'vehicle_v1',
      lemma: 'tractor',
    ),
    new Word.data(
      synsetId: 'bn:00002275n',
      levelId: 'vehicle_v1',
      lemma: 'aircraft',
    ),
    new Word.data(
      synsetId: 'bn:00007329n',
      levelId: 'vehicle_v1',
      lemma: 'bus',
    ),
    new Word.data(
      synsetId: 'bn:00066028n',
      levelId: 'vehicle_v1',
      lemma: 'train',
    ),
  ];

  static final sport_v1 = [
    // new Word.data(
    //   synsetId: 'bn:00023796n',
    //   levelId: 'sport_v1',
    //   lemma: 'Cricket',
    // ),
    new Word.data(
      synsetId: 'bn:00023320n',
      levelId: 'sport_v1',
      lemma: 'Tennis',
    ),
    new Word.data(
      synsetId: 'bn:00080220n',
      levelId: 'sport_v1',
      lemma: 'Volleyball',
    ),
    new Word.data(
      synsetId: 'bn:00068511n',
      levelId: 'sport_v1',
      lemma: 'Rugby',
    ),
    new Word.data(
      synsetId: 'bn:00041010n',
      levelId: 'sport_v1',
      lemma: 'Golf',
    ),
    new Word.data(
      synsetId: 'bn:00044331n',
      levelId: 'sport_v1',
      lemma: 'Ice_hockey',
    ),
    new Word.data(
      synsetId: 'bn:00049631n',
      levelId: 'sport_v1',
      lemma: 'Lacrosse',
    ),
  ];

  static final animal_v1 = [
    new Word.data(
      synsetId: 'bn:00036129n',
      levelId: 'animal_v1',
      lemma: 'fox',
    ),
    new Word.data(
      synsetId: 'bn:00059723n',
      levelId: 'animal_v1',
      lemma: 'otter',
    ),
    new Word.data(
      synsetId: 'bn:00021704n',
      levelId: 'animal_v1',
      lemma: 'rabbit',
    ),
    new Word.data(
      synsetId: 'bn:00033329n',
      levelId: 'animal_v1',
      lemma: 'Parrot',
    ),
    new Word.data(
      synsetId: 'bn:00049156n',
      levelId: 'animal_v1',
      lemma: 'lion',
    ),
    new Word.data(
      synsetId: 'bn:00031345n',
      levelId: 'animal_v1',
      lemma: 'horse',
    ),
  ];

  static final monument_v1 = [
    new Word.data(
      synsetId: 'bn:00018485n',
      levelId: 'monument_v1',
      lemma: 'Great_Wall',
    ),
    new Word.data(
      synsetId: 'bn:00049459n',
      levelId: 'monument_v1',
      lemma: 'Kremlin',
    ),
    new Word.data(
      synsetId: 'bn:00041586n',
      levelId: 'monument_v1',
      lemma: 'Pyramid',
    ),
    new Word.data(
      synsetId: 'bn:00050429n',
      levelId: 'monument_v1',
      lemma: 'Leaning_Tower',
    ),
    new Word.data(
      synsetId: 'bn:00074065n',
      levelId: 'monument_v1',
      lemma: 'Statue_of_Liberty',
    ),
    new Word.data(
      synsetId: 'bn:00052578n',
      levelId: 'monument_v1',
      lemma: 'Machu_Picchu',
    )
  ];

  static final start_v1 = [
    new Word.data(
      synsetId: 'bn:00015267n',
      levelId: 'start_v1',
      lemma: 'dog',
    ),
    new Word.data(
      synsetId: 'bn:00042379n',
      levelId: 'start_v1',
      lemma: 'water',
    ),
    new Word.data(
      synsetId: 'bn:00029980n',
      levelId: 'start_v1',
      lemma: 'eiffel_tower',
    ),
    new Word.data(
      synsetId: 'bn:00013077n',
      levelId: 'start_v1',
      lemma: 'bridge',
    ),
    new Word.data(
      synsetId: 'bn:00019887n',
      levelId: 'start_v1',
      lemma: 'clock',
    ),
  ];

  static List<Word> getLevelWords(String levelId) {
    if (levelId == "start_v1") {
      return start_v1;
    }
    if (levelId == "sport_v1") {
      return sport_v1;
    }
    if (levelId == "monument_v1") {
      return monument_v1;
    }
    if (levelId == "animal_v1") {
      return animal_v1;
    }
    if (levelId == "vehicle_v1") {
      return vehicle_v1;
    }

    return [];
  }
}
