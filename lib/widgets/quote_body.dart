
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:quotesbook/models/QuoteTheme.dart';

class QuoteBody extends StatelessWidget {

  Quote quote;

  QuoteBody({this.quote});

  static final quoteFontSize = 27.0;
  static final authorFontSize = quoteFontSize * 0.57;
  static final authorDescriptionFontSize = quoteFontSize * 0.40;

  @override
  Widget build(BuildContext context) {

    var theme = QuoteTheme.getThemeById(quote.themeId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
                '${quote.author.firstName} ${quote.author.lastName}',
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: authorFontSize,
                        color: theme.textColor)),
                textAlign: TextAlign.right,
              ),
              // Author description
              /*
              Text(
                quote.author.shortDescription,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: theme.textColor,
                        fontSize: authorDescriptionFontSize)),
                textAlign: TextAlign.right,
              ),
              */
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
    );
  }
}