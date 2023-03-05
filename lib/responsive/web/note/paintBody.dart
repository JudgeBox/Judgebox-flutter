import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PainterContainer extends StatefulWidget {
  final int id;
  final String title;
  const PainterContainer({Key? key, required this.id, required this.title}) : super(key: key);

  @override
  State<PainterContainer> createState() => _PainterContainer();

  @override
  Future<void> save() => _PainterContainer()._savePoints(id, title);
}

class _PainterContainer extends State<PainterContainer> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    PointPainter.points.add(<PaintData>[]);
    //PointPainter.points.clear();
    if(widget.title != "")
      _loadPoints(widget.id, widget.title);
  }

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    return LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxWidth),
              painter: PointPainter(id),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    PointPainter.points[id].add(PaintData(
                      position: details.localPosition,
                      color: Colors.red,
                      strokeWidth: 10.0,
                      strokeCap: StrokeCap.round,
                    ));
                  });
                },
              )
          );
        }
    );
  }

  Future<void> _savePoints(int id, String title) async {
    final List<Map<String, dynamic>> data = PointPainter.points[id].map((e) =>
        e.toMap()).toList();
    await _firestore.collection(title).doc("paint$id").delete();
    await _firestore.collection(title).doc("paint$id").set({'points': data});
  }

  Future<void> _loadPoints(int id, String title) async {
    final snapshot = await _firestore.collection(title).doc("paint$id").get();
    if (snapshot.exists) {
      final List<dynamic>? points = snapshot.data()?['points'];
      if (points != null) {
        setState(() {
          //PointPainter.points[id] = [];
          PointPainter.points[id].addAll(
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
  static List<List<PaintData>> points = [];
  final int id;

  PointPainter(this.id);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    if(points.length <= id) return;
    for (final point in points[id]) {
      paint.color = point.color;
      paint.strokeWidth = point.strokeWidth;
      paint.strokeCap = point.strokeCap;
      canvas.drawPoints(PointMode.points, [point.position], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}