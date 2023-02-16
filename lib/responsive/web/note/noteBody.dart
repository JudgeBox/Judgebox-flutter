import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:judgebox/constants.dart';

class NoteBody extends StatefulWidget {
  const NoteBody({Key? key}) : super(key: key);

  @override
  State<NoteBody> createState() => _NoteBody();
}

class _NoteBody extends State<NoteBody> {
  final buttonKey = GlobalKey();
  final textBoxKey = GlobalKey();
  bool _isTop = true;

  void _changeOrder() {
    setState(() {
      _isTop = !_isTop;
    });
  }

  late List<FocusNode> textFocusNode;

  late List<List<Widget>> pages;

  @override
  void initState() {
    super.initState();
    // Initialize pages with a single page.
    pages = [
      [
        PainterContainer(),
        TextContainer(),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> notes = [
      PainterContainer(),
      TextContainer(),
    ];
    // if (!_isTop) {
    //   for(var i = 0; i < page.length; i++) {
    //     page[i] = page[i].reversed.toList();
    //   }
    //   //notes = notes.reversed.toList();
    // }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(left: 250, right: 250),
                  color: Colors.white,
                  child: Stack(
                    children: pages[index],
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        pages = pages
                            .map((page) => page.reversed.toList())
                            .toList();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        // Add a new page to the end of the list.
                        print(pages.length);
                        pages.add([
                          PainterContainer(),
                          TextContainer(),
                        ]);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PainterContainer extends StatefulWidget {
  const PainterContainer({Key? key}) : super(key: key);

  @override
  State<PainterContainer> createState() => _PainterContainer();
}

class _PainterContainer extends State<PainterContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(
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
    ));
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
      if (points[i] != null)
        canvas.drawPoints(PointMode.points, [points[i]], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TextContainer extends StatefulWidget {
  const TextContainer({Key? key}) : super(key: key);

  @override
  State<TextContainer> createState() => _TextContainer();
}

class _TextContainer extends State<TextContainer> {
  @override
  Widget build(BuildContext context) {
    int listLength = 10;
    List<FocusNode> _focusNodes =
        List<FocusNode>.generate(listLength, (int index) => FocusNode());

    List<Widget> textFields = List<Widget>.generate(
        listLength,
        (int index) => RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              if (event is RawKeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  // 处理键盘上的向上箭头按键
                  _focusNodes[index - 1].requestFocus();
                } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  // 处理键盘上的向下箭头按键
                  _focusNodes[index + 1].requestFocus();
                }
              }
            },
            child: TextField(
              controller: TextEditingController(),
              focusNode: _focusNodes[index],
              onSubmitted: (String value) {
                if (index < listLength) {
                  _focusNodes[index + 1].requestFocus();
                }
              },
              onChanged: (value) {
                if (value.contains('\n')) {
                  // 检测到换行符时，将焦点移动到下一个TextField
                  _focusNodes[index + 1].requestFocus();
                }
              },
            )));

    return Container(
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child:
            ListView(padding: const EdgeInsets.all(8.0), children: textFields));
  }
}
