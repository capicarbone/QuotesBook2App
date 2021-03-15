import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

class QuoteTheme {
  String id;
  Color textColor;
  Color backgroundColor;
  Color secondaryColor;

  QuoteTheme({@required this.id, @required this.textColor, @required this.backgroundColor, @required this.secondaryColor});

  static int _lastIndex = 0;

  static final themes = [
    //QuoteTheme(id: 'amber', textColor: Colors.black , backgroundColor: Colors.amber),

    //QuoteTheme(id: 'white', textColor: Colors.black54 , backgroundColor: Colors.white, secondaryColor: Colors.black12),
    QuoteTheme(id: 'pink', textColor: Colors.white , backgroundColor: Colors.pink, secondaryColor: Colors.pink.shade600),
    QuoteTheme(id: 'teal', textColor: Colors.white , backgroundColor: Colors.teal, secondaryColor: Colors.teal.shade600),
    //QuoteTheme(id: 'lime', textColor: Colors.black , backgroundColor: Colors.lime, secondaryColor: Colors.lime.shade600),
    QuoteTheme(id: 'purple', textColor: Colors.white , backgroundColor: Colors.purple, secondaryColor: Colors.purple.shade600),
    QuoteTheme(id: 'orange', textColor: Colors.white , backgroundColor: Colors.orange, secondaryColor: Colors.orange.shade600),
    QuoteTheme(id: 'green', textColor: Colors.white , backgroundColor: Colors.green, secondaryColor: Colors.green.shade600),
  ];

  static QuoteTheme getThemeById(String id){
    return themes.firstWhere((theme) => theme.id == id);
  }

  static QuoteTheme getNextTheme() {
    _lastIndex = (_lastIndex + 1) % themes.length;
    return themes[_lastIndex];
  }
}