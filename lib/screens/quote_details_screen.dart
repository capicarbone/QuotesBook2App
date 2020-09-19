
import 'package:flutter/material.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:quotesbook/models/QuoteTheme.dart';
import 'package:quotesbook/widgets/quote_body.dart';

class QuoteDetailsScreen extends StatelessWidget {

  Quote _quote;
  QuoteTheme _theme;

  static final routeName = "/quote";

  @override
  Widget build(BuildContext context) {

    if (_quote == null){
      var args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _quote = args['quote'];
      _theme = QuoteTheme.getThemeById(_quote.themeId);
    }

    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ) ,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                QuoteBody(quote: _quote,),
                SizedBox(height: 120,) // For center taking account the app bar
              ],
            ),),
          ),));
  }
}
