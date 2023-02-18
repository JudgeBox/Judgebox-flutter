import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  late List<List<Widget>> pages;

  @override
  void initState() {
    super.initState();
    // Initialize pages with a single page.
    pages = const [
      [
        PainterContainer(),
        TextContainer(),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    // if (!_isTop) {
    //   for(var i = 0; i < page.length; i++) {
    //     page[i] = page[i].reversed.toList();
    //   }
    //   //notes = notes.reversed.toList();
    // }
    return Scaffold(
      body: Row(
        children: <Widget>[
          Column(
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        pages = pages
                            .map((page) => page.reversed.toList())
                            .toList();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        // Add a new page to the end of the list.
                        pages += const [
                          [
                            PainterContainer(),
                            TextContainer(),
                          ]
                        ];
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 250, right: 250, top: 10),
                        child: Column(
                          children: [
                            Text('Page ${index + 1}'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: Stack(
                                children: pages[index],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider()
                    ],
                  ),
                );
              },
            ),
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
    return CustomPaint(
      painter: PointPainter(),
      child: GestureDetector(
        onPanUpdate: (details) {
          RenderBox? box = context.findRenderObject() as RenderBox;
          PointPainter.points.add(box.globalToLocal(details.globalPosition));
          setState(() {});
        },
      ),
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
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Wrap(spacing: 8, children: textFields));
  }
}
