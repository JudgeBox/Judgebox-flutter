import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:judgebox/constants.dart';
import 'package:judgebox/responsive/web/note/paintBody.dart';
import 'package:judgebox/responsive/web/note/textBody.dart';

class NoteBody extends StatefulWidget {
  const NoteBody({Key? key}) : super(key: key);
  static List<List<String>> tmpText = <List<String>>[];
  static List<List<PaintData>> tmpPaint = <List<PaintData>>[];

  @override
  State<NoteBody> createState() => _NoteBody();
}

class _NoteBody extends State<NoteBody> {
  late TextEditingController title;
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
    NoteBody.tmpText.add(List.generate(10, (index) => ''));
    title = TextEditingController();

    super.initState();
    // Initialize pages with a single page.
    pages = [
      [
        PainterContainer(id: 0, title: ""),
        TextContainer(id: 0, tmpText: NoteBody.tmpText[0], title: ""),
      ],
    ];
  }

  @override
  void dispose() {
    NoteBody.tmpText.clear();
    NoteBody.tmpPaint.clear();
    title.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; // 設定左右間距比例
    final double Ratio = 0.1;

    // 計算新的左右間距值
    final double screenPadding = size.width * Ratio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: screenPadding),
          child: TextField(
            controller: title,
            decoration: InputDecoration(
              hintText: 'Enter text here',
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if(title.text == "") {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('No Title'),
                      content: const Text('Add title to save data'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                );
                return;
              }
              for (int i = 0; i < NoteBody.tmpText.length; i++) {
                PainterContainer(
                  id: i,
                  title: title.text,
                ).save();
                TextContainer(
                  id: i,
                  tmpText: NoteBody.tmpText[i],
                  title: title.text,
                ).save();
                Navigator.pop(context);
              }
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
                        //print(NoteBody.tmpText[0]);
                        _changeOrder();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        int len = pages.length;
                        NoteBody.tmpText.add(List.generate(10, (index) => ''));
                        pages += _isTop
                            ? [
                                [
                                  PainterContainer(
                                    id: len + 1,
                                    title: title.text,
                                  ),
                                  TextContainer(
                                      id: len,
                                      tmpText: NoteBody.tmpText[len - 1],
                                      title: title.text),
                                ]
                              ]
                            : [
                                [
                                  TextContainer(
                                      id: len,
                                      tmpText: NoteBody.tmpText[len - 1],
                                      title: title.text),
                                  PainterContainer(
                                    id: len,
                                    title: title.text,
                                  ),
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
