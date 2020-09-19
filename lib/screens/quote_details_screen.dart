
import 'package:flutter/material.dart';
import 'package:quotesbook/models/Quote.dart';

class QuoteDetailsScreen extends StatelessWidget {

  Quote _quote;

  static final routeName = "/quote";

  @override
  Widget build(BuildContext context) {

    if (_quote == null){
      var args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _quote = args['quote'];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
        body: Container(child: Center(child: Text(_quote.body),),));
  }
}
