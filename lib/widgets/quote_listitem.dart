import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/models/QuoteTheme.dart';
import 'package:quotesbook/widgets/bookmark.dart';

import '../models/Quote.dart';
import '../providers/saved_quotes.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteListItem extends StatelessWidget {
  Quote quote;

  QuoteListItem(this.quote) {
    if (quote.themeId == null) {
      quote.themeId = QuoteTheme.getRandomTheme().id;
    }
  }

  static final quoteFontSize = 27.0;
  static final authorFontSize = quoteFontSize * 0.57;
  static final authorDescriptionFontSize = quoteFontSize * 0.40;

  @override
  Widget build(BuildContext context) {
    var quotesProvider = Provider.of<SavedQuotes>(context, listen: false);

    var theme = QuoteTheme.getThemeById(quote.themeId);

    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 0),
      width: double.infinity,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      quote.body,
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: quoteFontSize,
                              fontWeight: FontWeight.bold,
                              color: theme.textColor)),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    color: theme.textColor,
                    height: 3.0,
                    width: 30,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${quote.author.firstName} ${quote.author.lastName},',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontSize: authorFontSize,
                                  color: theme.textColor)),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          quote.author.shortDescription,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: theme.textColor,
                                  fontSize: authorDescriptionFontSize)),
                          textAlign: TextAlign.right,
                        ),
                        /*
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color:
                                      quote.isFavorite ? Colors.amber : Colors.grey,
                                ),
                                onPressed: () {
                                  if (quote.isFavorite){
                                    quotesProvider.removeQuote(quote);
                                  }else {
                                    quotesProvider.saveQuote(quote);
                                  }
                                  
                                })
                          ],
                        )
                        */
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
