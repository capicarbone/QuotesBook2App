import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarBottomDecorationPainter extends CustomPainter {
  Color color;

  AppBarBottomDecorationPainter({this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    var path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);

    path.close();

    //var paint2 = Paint();
    //paint2.color = Colors.black.withOpacity(0.1);

    // canvas.drawLine(Offset(0, (size.height / 2) + 1),
    //Offset(size.width, (size.height / 2) + 1), paint2);
    canvas.drawShadow(path, Colors.black, 2, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _TopBarTitle extends StatefulWidget {
  String title;
  bool isExpanded;
  bool moveToRight;

  _TopBarTitle({this.title, this.isExpanded, this.moveToRight});

  @override
  __TopBarTitleState createState() => __TopBarTitleState();
}

class __TopBarTitleState extends State<_TopBarTitle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _fadeAnimation;
  Size containerSize = Size(200, 80);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInCubic);
    if (widget.isExpanded) {
      _controller.value = 1;
    }
  }

  Size _textSize(String text, TextStyle style, double scaleFactor) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textScaleFactor: scaleFactor,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  void didUpdateWidget(covariant _TopBarTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(
      widget.title,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 18),
    );

    final titleSize = _textSize(title.data, title.style, MediaQuery.of(context).textScaleFactor);

    final containerSize =
        Size(titleSize.width + titleSize.width * 2, titleSize.height);

    final startPosition = 0.0;
    final middlePosition = containerSize.width / 2 - titleSize.width / 2;
    final endPosition = containerSize.width - titleSize.width;

    double beginPosition;
    double finishPosition;

    if (widget.isExpanded){
      if (widget.moveToRight){
        beginPosition = endPosition;
        finishPosition = middlePosition;
      }else{
        beginPosition = startPosition;
        finishPosition = middlePosition;
      }
    }else{
      if (widget.moveToRight){
        beginPosition = startPosition;
        finishPosition = middlePosition;
      }else{
        beginPosition = endPosition;
        finishPosition = middlePosition;
      }
    }

    final begin = RelativeRect.fromSize(
        Rect.fromLTWH(beginPosition, 0,
            titleSize.width, titleSize.height),
        containerSize);
    final end = RelativeRect.fromSize(
        Rect.fromLTWH(finishPosition, 0,
            titleSize.width, titleSize.height),
        containerSize);

    return Center(
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        child: Stack(
          children: [
            PositionedTransition(
              rect: RelativeRectTween(begin: begin, end: end).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Topbar extends StatefulWidget {
  List<String> titles;
  int selectedIndex;
  Color color;
  double margin;

  static const double HEIGHT = 70;
  static const double SPIKE_HEIGHT = 7;

  Topbar({this.titles, this.selectedIndex, this.color, this.margin = 25});

  @override
  _TopbarState createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  var movingToRight = false;

  @override
  void didUpdateWidget(covariant Topbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex < oldWidget.selectedIndex) {
      movingToRight = false;
    }

    if (widget.selectedIndex > oldWidget.selectedIndex) {
      movingToRight = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var diamondMargin = 5.0;
    return Container(
      width: double.infinity,
      height: Topbar.HEIGHT,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Stack(
          children: [
            Positioned(
              bottom: 0,
              height: Topbar.SPIKE_HEIGHT,
              left: diamondMargin,
              width: constraints.maxWidth - (diamondMargin * 2),
              child: CustomPaint(
                painter: AppBarBottomDecorationPainter(color: widget.color),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: widget.color,
                  height: Topbar.HEIGHT - (Topbar.SPIKE_HEIGHT / 2),
                ),
                // optimize
                ...widget.titles
                    .map((e) => _TopBarTitle(
                          title: e,
                          isExpanded:
                              widget.titles.indexOf(e) == widget.selectedIndex,
                          moveToRight: movingToRight,
                        ))
                    .toList()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
