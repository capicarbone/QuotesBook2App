

import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:flutter/painting.dart' as painting;

class QuoteImageGenerator {
  final _logoProportion = 0.25;
  final _imageSize = 2400;


  Image quoteImage;
  painting.Color backgroundColor;

  QuoteImageGenerator({this.quoteImage, this.backgroundColor});

  get _verticalPadding => (_imageSize*0.02).toInt();

  Image _resizeImageByWidth(Image imageToResize, int width){
    return copyResize(imageToResize, width: width,
        height: width * imageToResize.height ~/ imageToResize.width );
  }

  Image _resizeImageByHeight(Image imageToResize, int height){
    return copyResize(imageToResize, height: height,
        width: height * imageToResize.width ~/ imageToResize.height );
  }

  Future<Image> _drawFooter(Image quoteImage) async {
    var logoImage = await _loadImageAsset();

    // Adjusting QB logo image size
    var newLogoWidth = (_imageSize * _logoProportion).toInt();
    logoImage = _resizeImageByWidth(logoImage, newLogoWidth);

    var destY = quoteImage.height - logoImage.height - _verticalPadding;
    var quoteImageXCenter = quoteImage.width ~/ 2;
    var logoImageXCenter = logoImage.width ~/ 2;

    copyInto(quoteImage, logoImage, dstY: destY, dstX: quoteImageXCenter - logoImageXCenter, blend: true);

    return logoImage;
  }

  Future<Image> _loadImageAsset() async {
    return decodePng((await rootBundle.load('assets/quote-logo.png')).buffer.asUint8List());
  }

  Future<List<int>> generateImage() async {

    var horizontalPadding = (_imageSize*0.05).toInt();

    var bgColor = backgroundColor;

    var finalQuoteImage = Image(_imageSize, _imageSize);

    // The image library use the form 0xAABBGGRR for colors
    finalQuoteImage.fill(painting.Color.fromARGB(bgColor.alpha, bgColor.blue, bgColor.green, bgColor.red).value);
    //finalQuoteImage = image.vignette(finalQuoteImage, amount: 1, end: 1.5);

    var logoImage = await _drawFooter(finalQuoteImage);

    var availableHeightForQuote = finalQuoteImage.height - logoImage.height - (_verticalPadding*4) - (logoImage.height ~/ 2);
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

    finalQuoteImage = copyInto(finalQuoteImage, quoteImage,
        dstX: _imageSize - quoteImage.width - horizontalPadding,
        dstY: _verticalPadding + (availableHeightForQuote ~/ 2) - (quoteImage.height ~/ 2)
    );

    return encodeJpg(finalQuoteImage);

  }

}