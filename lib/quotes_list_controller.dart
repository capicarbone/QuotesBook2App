
import 'package:flutter/material.dart';

class QuotesListController extends PageController {
  QuotesListController() : super(viewportFraction: 0.9);

  @override
  Future<void> animateToNextPage() {
    // TODO: implement nextPage
    return this.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}