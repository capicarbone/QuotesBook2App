
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotesbook/models/Quote.dart';


class QuoteText extends StatelessWidget {
  double minFontSize;
  TextSpan text;
  TextAlign align;
  BoxConstraints constraints;

  QuoteText(
      {this.text,
        this.constraints,
        this.minFontSize = 12,
        this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    var painter = TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        textScaleFactor: MediaQuery.of(context).textScaleFactor);

    painter.layout(
        minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);

    var adjusted = false;

    // If the default font size surpasses the constraints limit then it test to
    // reduces the font size in loop until we get a valid value or a minimum
    // has been reached.
    do {
      adjusted = painter.size.width <= constraints.maxWidth &&
          painter.size.height <= constraints.maxHeight;

      if (!adjusted) {
        var currentFontSize = painter.text.style.fontSize;
        var nextFontSize =
        ((currentFontSize - minFontSize) * 0.70 + minFontSize)
            .floor()
            .toDouble();
        var newText = TextSpan(
            text: text.text,
            style: text.style.copyWith(fontSize: nextFontSize));
        painter.text = newText;
        painter.layout(
            minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);
      }
    } while (!adjusted && painter.text.style.fontSize > minFontSize);

    return SizedBox(
      width: painter.size.width,
      height: painter.size.height,
      child: Text(
        text.text,
        style: painter.text.style,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class QuoteBody extends StatelessWidget {

  Quote quote;
  var quoteFontSize = 27.0;

  QuoteBody({this.quote, this.quoteFontSize: 27});

  @override
  Widget build(BuildContext context) {

    var textColor = Color(0xFF3B3840);

    final authorFontSize = quoteFontSize * 0.57;

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      var quoteConstraints = constraints.copyWith(maxHeight: constraints.maxHeight*0.7);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          QuoteText(
                  constraints: quoteConstraints,
                  text: TextSpan(
                      text: quote.body,
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: quoteFontSize,
                              fontWeight: FontWeight.bold,
                              color: textColor))
                  )
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
    });
  }
}