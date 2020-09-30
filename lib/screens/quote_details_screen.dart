import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
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

  QuoteTheme _theme;

  GlobalKey _repaintBoundaryKey = new GlobalKey();

  Uint8List _memoryImage;

  final _screenPadding = 22.0;

  Future<image.Image> _captureQuoteImage({pixelRatio: 1.0}) async {
    RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext.findRenderObject();
    ui.Image quoteShot = await boundary.toImage(pixelRatio: pixelRatio);
    final bytes = await quoteShot.toByteData(format: ui.ImageByteFormat.png);

    return image.decodePng(bytes.buffer.asUint8List());
  }

  image.Image _resizeImageByWidth(image.Image imageToResize, int width){
    return image.copyResize(imageToResize, width: width,
        height: width * imageToResize.height ~/ imageToResize.width );
  }

  image.Image _resizeImageByHeight(image.Image imageToResize, int height){
    return image.copyResize(imageToResize, height: height,
        width: height * imageToResize.width ~/ imageToResize.height );
  }

  void _generateImage() async {

    var logoProportion = 0.25;
    var imageSize = 2400;
    var verticalPadding = (imageSize*0.02).toInt();
    var horizontalPadding = (imageSize*0.05).toInt();
    var bgColor = _theme.backgroundColor;

    var finalQuoteImage = image.Image(imageSize, imageSize);

    // The image library use the form 0xAABBGGRR for colors
    finalQuoteImage.fill(Color.fromARGB(bgColor.alpha, bgColor.blue, bgColor.green, bgColor.red).value);
    finalQuoteImage = image.vignette(finalQuoteImage, amount: 0.2);

    var logoImage = image.decodePng((await rootBundle.load('assets/quote-logo.png')).buffer.asUint8List());
    var quoteImage = await _captureQuoteImage(pixelRatio: 3.0);

    // Adjusting QB logo image size
    var newLogoWidth = (imageSize * logoProportion).toInt();
    logoImage = _resizeImageByWidth(logoImage, newLogoWidth);

    var destY = finalQuoteImage.height - logoImage.height - verticalPadding;
    var quoteImageXCenter = finalQuoteImage.width ~/ 2;
    var logoImageXCenter = logoImage.width ~/ 2;

    finalQuoteImage = image.copyInto(finalQuoteImage, logoImage, dstY: destY, dstX: quoteImageXCenter - logoImageXCenter, blend: true);

    var availableHeightForQuote = finalQuoteImage.height - logoImage.height - (verticalPadding*4) - (logoImage.height ~/ 2);
    var availableWidthForQuote = finalQuoteImage.width - (horizontalPadding*2);

    // Adjusting if quote too small (width)
    if (quoteImage.width < availableWidthForQuote*0.95) {
      print("Image resized because too small on width");
      quoteImage = _resizeImageByWidth(quoteImage, (availableHeightForQuote*0.95).toInt());
    }

    // Adjusting if quote too big (height)
    if (quoteImage.height > availableHeightForQuote) {
      quoteImage = _resizeImageByHeight(quoteImage, availableHeightForQuote);
    }

    if (quoteImage.width > availableWidthForQuote) {
      print("Image resized because too big on width");
      quoteImage = _resizeImageByWidth(quoteImage, availableWidthForQuote);
    }





    finalQuoteImage = image.copyInto(finalQuoteImage, quoteImage,
        dstX: imageSize - quoteImage.width - horizontalPadding,
        dstY: verticalPadding + (availableHeightForQuote ~/ 2) - (quoteImage.height ~/ 2)
    );

    Share.file("A Quote from Quotesbook", 'quote.jpg', image.encodeJpg(finalQuoteImage), 'image/jpg');

    /*
    setState(() {
      _memoryImage = image.encodeJpg(finalQuoteImage);
    });
*/
  }

  void _onImageSharePressed() {
    _generateImage();
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
      child: Container(
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
                    height: 100,
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
/*
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
        */
      ],
    );
  }
}
