import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/models/QuoteTheme.dart';
import 'package:quotesbook/screens/quote_details_screen.dart';
import 'package:quotesbook/widgets/bookmark.dart';
import 'package:quotesbook/widgets/quote_body.dart';

import '../models/Quote.dart';
import '../providers/saved_quotes.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteListItem extends StatelessWidget {
  Quote quote;
  Function onTap;

  QuoteListItem({this.quote, this.onTap}) {
    if (quote.themeId == null) {
      quote.themeId = QuoteTheme.getRandomTheme().id;
    }
  }


  @override
  Widget build(BuildContext context) {
    var quotesProvider = Provider.of<SavedQuotes>(context, listen: false);

    var theme = QuoteTheme.getThemeById(quote.themeId);

    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 0),
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: theme.backgroundColor,
          elevation: 4,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 20, left: 20, bottom: 40, top: 0),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 50,
                          curve: Curves.bounceOut,
                          height: quote.isFavorite ? 50 : 30,
                          child: Bookmark(quote.isFavorite
                              ? Colors.amber
                              : theme.secondaryColor),
                        ),
                        if (quote.isFavorite) Container(
                          child: Center(
                            child: Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                          ),
                          width: 50,
                          height: 40,
                        )
                      ],
                    ),
                    onTap: () {
                      if (quote.isFavorite) {
                        quotesProvider.removeQuote(quote);
                      } else {
                        quotesProvider.saveQuote(quote);
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                Column(children: <Widget>[
                  SizedBox(height: 50,),
                  QuoteBody(quote: quote,)
                ],)
                ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
