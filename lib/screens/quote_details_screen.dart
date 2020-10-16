import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quotesbook/helpers/quote_image_generator.dart' as generator;
import 'package:quotesbook/models/Quote.dart';
import 'package:quotesbook/models/QuoteTheme.dart';
import 'package:quotesbook/providers/saved_quotes.dart';
import 'package:quotesbook/widgets/bookmark.dart';
import 'package:quotesbook/widgets/quote_body.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class QuoteDetailsScreen extends StatefulWidget {
  static final routeName = "/quote";

  @override
  _QuoteDetailsScreenState createState() => _QuoteDetailsScreenState();
}

class _QuoteDetailsScreenState extends State<QuoteDetailsScreen> {
  Quote _quote;
  var _debugMode = false;

  QuoteTheme _theme;

  GlobalKey _repaintBoundaryKey = new GlobalKey();

  Uint8List _memoryImage;

  var loading = false;

  final _screenPadding = 22.0;

  Future<image.Image> _captureQuoteImage({pixelRatio: 1.0}) async {
    RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext.findRenderObject();
    ui.Image quoteShot = await boundary.toImage(pixelRatio: pixelRatio);
    final bytes = await quoteShot.toByteData(format: ui.ImageByteFormat.png);

    return image.decodePng(bytes.buffer.asUint8List());
  }

  void _toggleLoader(bool enabled) {
    setState(() {
      loading = enabled;
    });
  }



  void _onImageSharePressed()  {

    _toggleLoader(true);

    _captureQuoteImage(pixelRatio: 3.0).then((quoteImage) {

      rootBundle.load('assets/quote-logo.png').then((footerImage) {
          return compute(generator.generateQuoteImage, {'quoteImage': quoteImage,
            'backgroundColor': _theme.backgroundColor,
            'footerLogo': image.decodePng(footerImage.buffer.asUint8List())});

      }).then((generatedImage) {

        _toggleLoader(false);

        Share.file("A Quote from Quotesbook", 'quote.jpg', generatedImage, 'image/jpg');

        if (_debugMode){
          setState(() {
            _memoryImage = generatedImage;
          });
        }

      }).catchError(() => _toggleLoader(false));

    });


  }

  void _onTextSharePressed() {
    Share.text('A quote from Quotesbook', _quote.toText(), 'text/plain');
  }

  Widget _onSharePressed(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return Container(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.textsms),
              title: Text("Text", ),
              onTap: (){
                _onTextSharePressed();
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Image", ),
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

  Widget _buildQuoteBody() {

    var fontSize = _quote.body.length < 174 ? 33.0 : 27.0;
    return Container(
      child: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(_screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RepaintBoundary(
                  key: _repaintBoundaryKey,
                  child: QuoteBody(
                    quoteFontSize:  fontSize,
                    quote: _quote,
                  ),
                ),               // For center taking account the app bar
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedMarker(SavedQuotes quotesProvider) {
    return GestureDetector(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 50,
              curve: Curves.bounceOut,
              height: _quote.isFavorite ? 50 : 30,
              child: Bookmark(
                  _quote.isFavorite ? Colors.amber : _theme.secondaryColor),
            ),
            if (_quote.isFavorite)
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
          if (_quote.isFavorite) {
            quotesProvider.removeQuote(_quote);
          } else {
            quotesProvider.saveQuote(_quote);
          }
        });
  }

  Widget _buildBottomMenu(BuildContext ctx, SavedQuotes quotesProvider) {
    return Container(
      height: 32,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (loading)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          if (!loading)
          Container(
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
            height: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      if (_quote.isFavorite) {
                        quotesProvider.removeQuote(_quote);
                      } else {
                        quotesProvider.saveQuote(_quote);
                      }
                    },
                    icon: _quote.isFavorite
                        ? Icon(
                            Icons.bookmark,
                            color: Colors.amber,
                          )
                        : Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                          ),
                    label: Text("")),
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
    var quotesProvider = Provider.of<SavedQuotes>(context);

    if (_quote == null) {
      var args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _quote = args['quote'];
      _theme = QuoteTheme.getThemeById(_quote.themeId);
    }

    return Stack(
      children: <Widget>[
        Scaffold(
            backgroundColor: _theme.backgroundColor,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: _buildQuoteBody(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildBottomMenu(context, quotesProvider),
                  SizedBox(
                    height: _screenPadding,
                  )
                ],
              ),
            )),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: _screenPadding),
            alignment: Alignment.topRight,
            child: _buildSavedMarker(quotesProvider),
          ),
        ),
        if (_debugMode)
        SafeArea(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 3)
            ),
            child: _memoryImage != null ?
                Image.memory(_memoryImage)  : Placeholder(),
          ),
        )

      ],
    );
  }
}
