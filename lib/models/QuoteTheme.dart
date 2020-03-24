import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

class QuoteTheme {
  String id;
  Color textColor;
  Color backgroundColor;

  QuoteTheme({@required this.id, @required this.textColor, @required this.backgroundColor});

  static final themes = [
    QuoteTheme(id: 'amber', textColor: Colors.black , backgroundColor: Colors.amber),
    QuoteTheme(id: 'orange', textColor: Colors.white , backgroundColor: Colors.orange),
    QuoteTheme(id: 'purple', textColor: Colors.white , backgroundColor: Colors.purple),
    //QuoteTheme(id: 'cyan', textColor: Colors.black , backgroundColor: Colors.cyan),
    QuoteTheme(id: 'pink', textColor: Colors.white , backgroundColor: Colors.pink),
    QuoteTheme(id: 'teal', textColor: Colors.white , backgroundColor: Colors.teal),
    QuoteTheme(id: 'lime', textColor: Colors.black , backgroundColor: Colors.lime),
    QuoteTheme(id: 'green', textColor: Colors.white , backgroundColor: Colors.green),
  ];

  static QuoteTheme getThemeById(String id){
    return themes.firstWhere((theme) => theme.id == id);
  }

  static QuoteTheme getRandomTheme() {
    var rng = Random();
    return themes[rng.nextInt(themes.length)];
  }
}