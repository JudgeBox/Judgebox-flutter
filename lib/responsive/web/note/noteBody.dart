import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';

class NoteBody extends StatefulWidget {
  const NoteBody({Key? key}) : super(key: key);

  @override
  State<NoteBody> createState() => _NoteBody();
}

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
                    onPanUpdate: (details) {
                      RenderBox? box = context.findRenderObject() as RenderBox;
                      PointPainter.points.add(box.globalToLocal(details.globalPosition));
                      setState(() {});
                    },
                  ),
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
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length; i++) {
      if (points[i] != null) canvas.drawPoints(PointMode.points, [points[i]], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}