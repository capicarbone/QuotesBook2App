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
  Quote previousQuote;
  Function onTap;

  QuoteListItem({this.quote, this.previousQuote, this.onTap}) {
    if (quote.themeId == null) {
      quote.themeId = QuoteTheme.getRandomTheme().id;
    }
  }

  @override
  Widget build(BuildContext context) {
    var quotesProvider = Provider.of<SavedQuotes>(context, listen: false);

    var theme = QuoteTheme.getThemeById(quote.themeId);
    var prevTheme = (previousQuote == null) ? null : QuoteTheme.getThemeById(previousQuote.themeId);

    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          color: theme.backgroundColor,
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 20,
                child: Stack(
                  children: [
                    Container(
                      color: (prevTheme == null) ? Colors.grey.shade50 : prevTheme.backgroundColor
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, -3),
                              blurRadius: 2,
                              color: Color.fromARGB(70, 0, 0, 0)
                            )
                          ],
                          color: theme.backgroundColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45))
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 22,
                top: 6,
                child: GestureDetector(
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
                        if (quote.isFavorite)
                          Container(
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
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    EdgeInsets.only(right: 20, left: 20, bottom: 40, top: 0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Expanded(
                        child: Center(
                            child: QuoteBody(
                      quote: quote,
                    )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
