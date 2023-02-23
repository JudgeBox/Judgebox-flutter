import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PainterContainer extends StatefulWidget {
  final int id;

  const PainterContainer({Key? key, required this.id}) : super(key: key);

  @override
  State<PainterContainer> createState() => _PainterContainer();

  @override
  Future<void> save() => _PainterContainer()._savePoints();
}

class _PainterContainer extends State<PainterContainer> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    _loadPoints();
    int id = widget.id;
    return LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxWidth),
              painter: PointPainter(),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    PointPainter.points.add(PaintData(
                      position: details.localPosition,
                      color: Colors.red,
                      strokeWidth: 4.0,
                      strokeCap: StrokeCap.round,
                    ));
                  });
                },
              )
          );
        }
    );
  }

  Future<void> _savePoints() async {
    final List<Map<String, dynamic>> data = PointPainter.points.map((e) =>
        e.toMap()).toList();
    await _firestore.collection('points').add({'points': data});
  }

  Future<void> _loadPoints() async {
    final snapshot = await _firestore.collection('points').get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      if (data.containsKey('points')) {
        final List<dynamic> points = data['points'];
        setState(() {
          PointPainter.points.clear();
          PointPainter.points.addAll(
              points.map((e) => PaintData.fromMap(e)).toList());
        });
      }
    }
  }
}

class PaintData {
  final Offset position;
  final Color color;
  final double strokeWidth;
  final StrokeCap strokeCap;

  PaintData({
    required this.position,
    required this.color,
    required this.strokeWidth,
    required this.strokeCap,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': position.dx,
      'y': position.dy,
      'color': color.value,
      'strokeWidth': strokeWidth,
      'strokeCap': strokeCap.index,
    };
  }

  static PaintData fromMap(Map<String, dynamic> map) {
    return PaintData(
      position: Offset(map['x'], map['y']),
      color: Color(map['color']),
      strokeWidth: map['strokeWidth'],
      strokeCap: StrokeCap.values[map['strokeCap']],
    );
  }
}

class PointPainter extends CustomPainter {
  static List<PaintData> points = <PaintData>[];

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    for (final point in points) {
      paint.color = point.color;
      paint.strokeWidth = point.strokeWidth;
      paint.strokeCap = point.strokeCap;
      canvas.drawPoints(PointMode.points, [point.position], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}