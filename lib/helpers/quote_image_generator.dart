import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:flutter/painting.dart' as painting;

class QuoteImageGenerator {

  final _imageSize = 2400;

  Image quoteImage;
  Image footerLogo;
  painting.Color backgroundColor;
  painting.Color frameColor;

  QuoteImageGenerator({this.quoteImage, this.backgroundColor, this.frameColor, this.footerLogo});

  get _imagePadding => (_imageSize * 0.04).toInt();
  get _insetPadding => (_imagePadding*2).toInt();
  get _borderThickness => _imagePadding * 0.19;

  Image _resizeImageByWidth(Image imageToResize, int width) {
    return copyResize(imageToResize,
        width: width,
        height: width * imageToResize.height ~/ imageToResize.width);
  }

  Image _resizeImageByHeight(Image imageToResize, int height) {
    return copyResize(imageToResize,
        height: height,
        width: height * imageToResize.width ~/ imageToResize.height);
  }

  Future<Image> _drawFrame(Image quoteImage) async {

    var color = painting.Color.fromARGB(frameColor.alpha, frameColor.blue, frameColor.green, frameColor.red).value;
    var positionAdjustmet = _borderThickness ~/ 2;

    var borders = {
      'top-left' : [_imagePadding, _imagePadding],
      'top-right' : [quoteImage.width - _imagePadding, _imagePadding],
      'bottom-left': [_imagePadding, quoteImage.height - _imagePadding ],
      'bottom-right': [quoteImage.width - _imagePadding, quoteImage.height - _imagePadding]
    };

    var framedImage = drawLine(quoteImage,
        borders['top-left'][0],
        borders['top-left'][1] - positionAdjustmet,
        borders['bottom-left'][0],
        borders['bottom-left'][1] + positionAdjustmet,
        color, thickness: _borderThickness);

    framedImage = drawLine(quoteImage,
        borders['top-left'][0],
        borders['top-left'][1],
        borders['top-right'][0],
        borders['top-right'][1],
        color, thickness: _borderThickness);


    framedImage = drawLine(quoteImage,
        borders['top-right'][0],
        borders['top-right'][1] - positionAdjustmet,
        borders['bottom-right'][0],
        borders['bottom-right'][1] + positionAdjustmet,
        color, thickness: _borderThickness);

    framedImage = drawLine(quoteImage,
        borders['bottom-left'][0],
        borders['bottom-left'][1],
        borders['bottom-right'][0],
        borders['bottom-right'][1],
        color, thickness: _borderThickness);

    return framedImage;

  }

  Future<Image> _drawFooter(Image quoteImage) async {
    final logoProportion = _imagePadding / quoteImage.height;
    var qbLogo = _resizeImageByHeight(footerLogo, (quoteImage.height * logoProportion ).toInt());

    final logoHeightCenterPosition = quoteImage.height - _imagePadding - (_borderThickness ~/ 2);
    final imageWidthCenter = quoteImage.width ~/ 2;

    var logoPosition = {'x': imageWidthCenter - qbLogo.width ~/ 2, 'y': logoHeightCenterPosition - qbLogo.height ~/ 2};

    final backgroundMargin = (qbLogo.width * 0.25).toInt();
    final logoBackground = Image(qbLogo.width + backgroundMargin*2, qbLogo.height, channels: Channels.rgba);
    logoBackground.fill(0xFFFFFFFF);

    var result = copyInto(quoteImage, logoBackground, dstX: logoPosition['x'] - backgroundMargin, dstY: logoPosition['y']);

    return copyInto(result, qbLogo, dstX: logoPosition['x'] , dstY: logoPosition['y']);

  }

  Future<List<int>> generateImage() async {

    var bgColor = backgroundColor;

    var finalQuoteImage = Image(_imageSize, _imageSize);

    // The image library use the form 0xAABBGGRR for colors
    finalQuoteImage.fill(painting.Color.fromARGB(
            bgColor.alpha, bgColor.blue, bgColor.green, bgColor.red)
        .value);
    //finalQuoteImage = image.vignette(finalQuoteImage, amount: 1, end: 1.5);

    finalQuoteImage = await _drawFrame(finalQuoteImage);
    finalQuoteImage = await _drawFooter(finalQuoteImage);

    var availableHeightForQuote =
        finalQuoteImage.height - _imagePadding * 2 - _insetPadding * 2;
    var availableWidthForQuote =
        finalQuoteImage.width - _imagePadding * 2 - _insetPadding * 2;

    // Adjusting if quote too small (width)
    if (quoteImage.width < availableWidthForQuote * 0.95) {
      print("Image resized because too small on width");
      quoteImage = _resizeImageByWidth(
          quoteImage, (availableHeightForQuote * 0.95).toInt());
    }

    // Adjusting if quote too big (height)
    if (quoteImage.height > availableHeightForQuote) {
      quoteImage = _resizeImageByHeight(quoteImage, availableHeightForQuote);
    }

    if (quoteImage.width > availableWidthForQuote) {
      print("Image resized because too big on width");
      quoteImage = _resizeImageByWidth(quoteImage, availableWidthForQuote);
    }

    finalQuoteImage = copyInto(finalQuoteImage, quoteImage,
        dstX: (finalQuoteImage.width ~/ 2) -
            (quoteImage.width ~/ 2),
        dstY:
            (finalQuoteImage.height ~/ 2) -
            (quoteImage.height ~/ 2));

    return encodeJpg(finalQuoteImage);
  }

  Future<List<int>> generate() async {
    return generateImage();
  }
}

Future<List<int>> generateQuoteImage(Map<String, dynamic> params) async {
  var generator = QuoteImageGenerator(
      quoteImage: params['quoteImage'],
      frameColor: params['frameColor'],
      backgroundColor: params['backgroundColor'],
      footerLogo: params['footerLogo']);

  return generator.generate();
}
