import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';

class NoteBody extends StatefulWidget {
  const NoteBody({Key? key}) : super(key: key);

  @override
  State<NoteBody> createState() => _NoteBody();
}
//文字方塊
class _NoteBody extends State<NoteBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(left: 250, right: 250),
          child: Column(children: [
            Expanded(child: LayoutBuilder(builder: (context, constraints) {
              return CustomPaint(
                painter: PointPainter(),
                child: Container(
                  child: GestureDetector(
                    onPanDown: (details) {
                      // Handle the user's mouse down event
                    },
                    onPanUpdate: (details) {
                      RenderBox? box = context.findRenderObject() as RenderBox;
                      PointPainter.points.add(box.globalToLocal(details.globalPosition));
                      setState(() {});
                    },
                    child: Container(
                      // Use a Container widget to set the background color and size of the text field
                      color: Colors.blue,
                      width: 300,
                      height: 200,
                      child: TextField(
                        maxLines: 3, // This will create a multi-line text field with 3 lines
                      ),
                    ),
                  )
                  ,
                ),
              );
            })),
          ])),
    );
  }
}

class PointPainter extends CustomPainter {
  static List<Offset> points = <Offset>[];

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length; i++) {
      if (points[i] != null) canvas.drawPoints(PointMode.points, [points[i]], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
