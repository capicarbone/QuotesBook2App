import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;
import 'package:quotesbook/helpers/quote_image_generator.dart' as generator;

import 'package:quotesbook/models/QuoteTheme.dart';
import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/widgets/bookmark.dart';
import 'package:quotesbook/widgets/quote_body.dart';

import '../models/Quote.dart';
import '../providers/saved_quotes.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class QuoteListItem extends StatelessWidget {
  Quote quote;
  Quote previousQuote;
  Function onTap;
  GlobalKey _repaintBoundaryKey = GlobalKey();

  var loading = false;

  QuoteListItem({this.quote, this.previousQuote, this.onTap});

  void _onTextSharePressed() {
    Share.text('A quote from Quotesbook', quote.toText(), 'text/plain');
  }

  void _toggleLoader(bool enabled) {}

  Future<image.Image> _captureQuoteImage({pixelRatio: 1.0}) async {
    RenderRepaintBoundary boundary =
        _repaintBoundaryKey.currentContext.findRenderObject();
    ui.Image quoteShot = await boundary.toImage(pixelRatio: pixelRatio);
    final bytes = await quoteShot.toByteData(format: ui.ImageByteFormat.png);

    return image.decodePng(bytes.buffer.asUint8List());
  }

  void _onImageSharePressed() {
    _toggleLoader(true);

    _captureQuoteImage(pixelRatio: 3.0).then((quoteImage) {
      rootBundle.load('assets/quote-logo.png').then((footerImage) {
        return compute(generator.generateQuoteImage, {
          'quoteImage': quoteImage,
          'backgroundColor':
              QuoteTheme.getThemeById(quote.themeId).backgroundColor,
          'footerLogo': image.decodePng(footerImage.buffer.asUint8List())
        });
      }).then((generatedImage) {
        _toggleLoader(false);

        Share.file("A Quote from Quotesbook", 'quote.jpg', generatedImage,
            'image/jpg');

        /*
        if (_debugMode){
          setState(() {
            _memoryImage = generatedImage;
          });
        }
         */
      }).catchError(() => _toggleLoader(false));
    });
  }

  Widget _onSharePressed(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.textsms),
                  title: Text(
                    AppLocalizations.of(ctx).shareQuoteTextOption,
                  ),
                  onTap: () {
                    _onTextSharePressed();
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text(
                    AppLocalizations.of(ctx).shareQuoteImageOption,
                  ),
                  onTap: () {
                    _onImageSharePressed();
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _buildBottomMenu(BuildContext ctx) {
    return Container(
      height: 32,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (loading)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          if (!loading)
            Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50))),
              height: 32,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () {
                        _onSharePressed(ctx);
                      },
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      label: Text("")),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var quotesProvider = Provider.of<SavedQuotes>(context, listen: false);

    var screenSize = MediaQuery.of(context).size;
    var fontSize = quote.body.length < 174
        ? screenSize.width * 0.0825
        : screenSize.width * 0.0675;

    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Expanded(
                      // Quote card
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, -3),
                                  blurRadius: 2,
                                  color: Color.fromARGB(70, 0, 0, 0))
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2))),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2)),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 40,
                                      right: 40,
                                      top: 20,
                                      bottom: 20),
                                  child: Center(
                                      child: RepaintBoundary(
                                    key: _repaintBoundaryKey,
                                    child: QuoteBody(
                                      quoteFontSize: fontSize,
                                      quote: quote,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 5,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    width: 130,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Quotes",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        Text(
                                          "Book",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [_buildBottomMenu(context)],
                    )
                  ],
                ),
              ),

              // Bookmark
              /*
              Positioned(
                right: 22,
                child: GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 70,
                          curve: Curves.bounceOut,
                          height: quote.isFavorite ? 70 : 42,
                          child: Bookmark(quote.isFavorite
                              ? Colors.amber
                              : Colors.black12),
                        ),
                        /*
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
                                  ) */
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
               */
            ],
          ),
        ),
      ),
    );
  }
}
