import 'package:flutter/material.dart';

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
  
  _TopBarTitle({this.title, this.isExpanded});

  @override
  __TopBarTitleState createState() => __TopBarTitleState();
}

class __TopBarTitleState extends State<_TopBarTitle> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInCubic);
    if (widget.isExpanded){
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant _TopBarTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded){
      _controller.forward();
    }else{
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        widget.title.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Topbar extends StatelessWidget {
  List<String> titles;
  int selectedIndex;
  Color color;
  double margin;

  static const double HEIGHT = 70;
  static const double SPIKE_HEIGHT = 7;

  Topbar({this.titles, this.selectedIndex, this.color, this.margin = 25});

  @override
  Widget build(BuildContext context) {
    var diamondMargin = 5.0;
    return Container(
      width: double.infinity,
      height: HEIGHT,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Stack(
          children: [
            Positioned(
              bottom: 0,
              height: SPIKE_HEIGHT,
              left: diamondMargin,
              width: constraints.maxWidth - (diamondMargin * 2),
              child: CustomPaint(
                painter: AppBarBottomDecorationPainter(color: color),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: color,
                  height: HEIGHT - (SPIKE_HEIGHT / 2),
                ),
                // optimize
                ...titles
                    .map((e) => _TopBarTitle(
                          title: e,
                          isExpanded: titles.indexOf(e) == selectedIndex,
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
