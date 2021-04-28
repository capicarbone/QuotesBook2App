
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotesbook/models/Quote.dart';
import 'package:quotesbook/models/QuoteTheme.dart';

class QuoteBody extends StatelessWidget {

  Quote quote;
  var quoteFontSize = 27.0;

  QuoteBody({this.quote, this.quoteFontSize: 27});

  @override
  Widget build(BuildContext context) {

    var textColor = Color(0xFF3B3840);

    final authorFontSize = quoteFontSize * 0.57;
    final authorDescriptionFontSize = quoteFontSize * 0.40;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                    color: textColor)),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          color: textColor,
          height: 3.0,
          width: 30,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '${quote.author.firstName} ${quote.author.lastName}',
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: authorFontSize,
                        color: textColor)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }
}