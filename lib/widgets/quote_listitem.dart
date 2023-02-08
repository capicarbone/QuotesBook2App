import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;
import 'package:quotesbook/helpers/quote_image_generator.dart' as generator;

import 'package:quotesbook/helpers/app_localizations.dart';
import 'package:quotesbook/widgets/quote_body.dart';

import '../models/Quote.dart';
import '../providers/quotes.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class QuoteListItem extends StatefulWidget {
  Quote quote;
  Function() onTap;

  QuoteListItem({required this.quote, required this.onTap});

  @override
  _QuoteListItemState createState() => _QuoteListItemState();
}

class _QuoteListItemState extends State<QuoteListItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  GlobalKey _repaintBoundaryKey = GlobalKey();

  static var fontLoadWaited = false;

  final _shareDebugMode = false;

  Uint8List? _memoryImage;

  var loading = false;
  var transitioning = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this
    );
    _fadeInAnimation = _animationController.drive(Tween<double>(begin: 0, end: 1));
    _fadeOutAnimation = _animationController.drive(Tween<double>(begin: 1, end: 0));
    _animationController.value = 1;

    _waitForSomeMoment();
  }

  void _waitForSomeMoment() async {
    if (!fontLoadWaited){
      await Future.delayed(Duration(milliseconds: 300), (){
        setState(() {
          fontLoadWaited = true;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _onTextSharePressed() {
    Share.text('A quote from Quotesbook', widget.quote.toText(), 'text/plain');
  }

  void _toggleLoader(bool enabled) {
    setState(() {
      loading = enabled;
      if (loading){
        _animationController.reverse();
      }else{
        _animationController.forward();
      }
    });
  }

  Future<image.Image> _captureQuoteImage({pixelRatio = 1.0}) async {
    RenderRepaintBoundary boundary =
        _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image quoteShot = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData bytes = (await quoteShot.toByteData(format: ui.ImageByteFormat.png))!;

    return image.decodePng(bytes.buffer.asUint8List())!;
  }

  void _onImageSharePressed(BuildContext context) {
    _toggleLoader(true);

    _captureQuoteImage(pixelRatio: 3.0).then((quoteImage) {
      rootBundle.load('assets/quote-logo.png').then((footerImage) {
        return compute(generator.generateQuoteImage, {
          'quoteImage': quoteImage,
          'backgroundColor': Colors.white,
          'frameColor': Theme.of(context).primaryColor,
          'footerLogo': image.decodePng(footerImage.buffer.asUint8List())
        });
      }).then((generatedImage) {
        _toggleLoader(false);

        if (_shareDebugMode) {
          setState(() {
            _memoryImage = Uint8List.fromList(generatedImage);
          });
        } else {
          Share.file("A Quote from Quotesbook", 'quote.jpg', generatedImage,
              'image/jpg');
        }
      }).catchError((err) {
        developer.log("on image generation", error: err);
        _toggleLoader(false);
      });
    });
  }

  _onSharePressed(BuildContext ctx) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.android){

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
                      _onImageSharePressed(ctx);
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            );
          });
    }

    if (platform == TargetPlatform.iOS){

      showCupertinoModalPopup(context: ctx, builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(AppLocalizations.of(ctx).shareQuoteAs),
          cancelButton: CupertinoActionSheetAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(ctx).cancelAction)
          ),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(onPressed: () {
              _onTextSharePressed();
              Navigator.pop(context);
            }, child: Text(AppLocalizations.of(context).shareQuoteTextOption)),
            CupertinoActionSheetAction(
              onPressed: (){
                _onImageSharePressed(context);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).shareQuoteImageOption),
            )
          ]
      ));
    }

  }

  Widget _buildBottomMenu(BuildContext ctx) {
    final quotesProvider = Provider.of<Quotes>(ctx, listen: false);
    final saved = widget.quote.isFavorite;

    var buttonsStyle = TextButton.styleFrom(
        primary: Theme.of(ctx).primaryColor,
        textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500));

    final actionsButtons = [
      if (saved)
        TextButton(
            style: buttonsStyle,
            child: Text(AppLocalizations.of(context).removeAction.toUpperCase()),
            onPressed: () {
              if (!loading)
                quotesProvider.removeQuote(widget.quote);
            }),
      if (!saved)
        TextButton(
          onPressed: () {
            if (!loading)
              quotesProvider.saveQuote(widget.quote);
          },
          child: Text(AppLocalizations.of(context).saveAction.toUpperCase()),
          style: buttonsStyle,
        ),
      TextButton(
          style: buttonsStyle,
          child: Text(AppLocalizations.of(context).shareAction.toUpperCase()),
          onPressed: () {
            if (!loading)
              _onSharePressed(ctx);
          }),
    ];
    return Stack(
      children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: FadeTransition(
                opacity: _fadeOutAnimation,
                child: Container(width: 150, child: LinearProgressIndicator(backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor) ,),),
              ),
            ),
          ),
        FadeTransition(
          opacity: _fadeInAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ...actionsButtons,
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final listItem = Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: widget.onTap,
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
                                  offset: Offset(0, 3),
                                  blurRadius: 2,
                                  color: Color.fromARGB(70, 0, 0, 0))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(2))),
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
                                      left: 40, right: 40, top: 20, bottom: 20),
                                  child: Center(
                                      child: RepaintBoundary(
                                    key: _repaintBoundaryKey,
                                    child: QuoteBody(
                                      quote: widget.quote,
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
                                        Text("Quotes",
                                            style: GoogleFonts.robotoSlab(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        Text(
                                          "Book",
                                          style: GoogleFonts.robotoSlab(
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
            ],
          ),
        ),
      ),
    );

    if (_shareDebugMode) {
      return Stack(
        children: [
          listItem,
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 3)),
              width: 300,
              height: 300,
              child: _memoryImage != null
                  ? Image.memory(_memoryImage!)
                  : Placeholder()),
        ],
      );
    } else {
      return listItem;
    }
  }
}
