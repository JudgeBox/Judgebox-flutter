import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:judgebox/constants.dart';
import 'package:judgebox/responsive/web/note/paintBody.dart';

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
        PainterContainer(id: 0),
        TextContainer(id: 0),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final PainterContainer paint;
    // 設定左右間距比例
    final double Ratio = 0.1;

    // 計算新的左右間距值
    final double screenPadding = size.width * Ratio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              PainterContainer(id: 0).save();
            },
            child: Text("Save"),
          ),
        ],
      ),
      backgroundColor: judgeBackground,
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
                        _changeOrder();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        // Add a new page to the end of the list.
                        int len = pages.length;
                        pages += _isTop ? [[
                            PainterContainer(id: len),
                            TextContainer(id: len),
                          ]] : [[
                            TextContainer(id: len),
                            PainterContainer(id: len),
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
                        padding: EdgeInsets.only(
                            left: screenPadding, right: screenPadding, top: 10),
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

class TextContainer extends StatefulWidget {
  final int id;

  const TextContainer({Key? key, required this.id}) : super(key: key);

  @override
  State<TextContainer> createState() => _TextContainer();
}

class _TextContainer extends State<TextContainer> {
  @override
  Widget build(BuildContext context) {
    int id = widget.id;
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
                  _focusNodes[index - 1].requestFocus();
                } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
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
