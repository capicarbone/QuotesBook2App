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
    final desirableFontSize = text.style.fontSize;

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

    final sortedWords = text.text.split(" ")
      ..sort((a, b) => b.length.compareTo(a.length));
    final largestWordLength = sortedWords[0].length;

    final measuredFontSize = painter.text.style.fontSize;

    // It can't apply an adjustment if the font size is lower than
    // 28px since a lower number will lead to a negative adjustment value
    // and will increase the font size instead.
    if (largestWordLength > 7 && measuredFontSize > 28) {

      // The constant in the adjustment are calculated as a line equation (mx + b)
      // using (font size calculated, min font size for correct adjustment) tuples => (50, 12), (38, 12)
      // as points for determine the constants.
      // This is not a definitive solution for clipped large words yet, but has
      // decreased considerably the number of occurrences.
      // In a better solution I think should consider the largest word length.
      final fontSizeAdjustment = (0.583 * measuredFontSize - 17.17);
      painter.text = TextSpan(
          text: text.text,
          style: painter.text.style.copyWith(
              // the constant for
              fontSize: painter.text.style.fontSize - fontSizeAdjustment));
      painter.layout(
          minWidth: constraints.minWidth, maxWidth: constraints.maxWidth);
    }

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
  var quoteFontSize;

  QuoteBody({this.quote, this.quoteFontSize: 50.0});

  @override
  Widget build(BuildContext context) {
    var textColor = Theme.of(context).primaryColor;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var quoteConstraints =
          constraints.copyWith(maxHeight: constraints.maxHeight * 0.7);
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
                          fontWeight: FontWeight.w800,
                          color: textColor)))),
          SizedBox(
            height: 25,
          ),
          Container(
            color: textColor,
            height: 6,
            width: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${quote.author.firstName} ${quote.author.lastName}',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                      textStyle: TextStyle(fontSize: 15, color: textColor)),
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
