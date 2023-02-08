import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bookmark extends StatelessWidget {

  Color color;
  int apexHeight;

  Bookmark({required this.color, required this.apexHeight});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BookmarkPainter(color, apexHeight)
    );
  }
}



class _BookmarkPainter extends CustomPainter {

  Color color;
  int apexHeight;

  _BookmarkPainter(this.color, this.apexHeight);

  @override
  void paint(Canvas canvas, Size size) {
        Paint paint = Paint()
      ..color = color;
    

      Path path = Path();
      
      path.lineTo(size.width, 0);      
      path.lineTo(size.width, size.height);
      path.lineTo(size.width / 2, size.height - apexHeight);
      path.lineTo(0, size.height);
      

      path.close();
      canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}