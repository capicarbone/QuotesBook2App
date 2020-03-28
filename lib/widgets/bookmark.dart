import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bookmark extends StatelessWidget {

  Color color;

  Bookmark(@required this.color);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BookmarkPainter(color)
    );
  }
}



class BookmarkPainter extends CustomPainter {

  Color color;

  BookmarkPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
        Paint paint = Paint()
      ..color = color;
    

      Path path = Path();
      
      path.lineTo(size.width, 0);      
      path.lineTo(size.width, size.height);
      path.lineTo(size.width / 2, size.height * 0.7);
      path.lineTo(0, size.height);
      

      path.close();
      canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}