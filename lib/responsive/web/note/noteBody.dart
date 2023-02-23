import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:judgebox/constants.dart';
import 'package:judgebox/responsive/web/note/paintBody.dart';
import 'package:judgebox/responsive/web/note/textBody.dart';

class NoteBody extends StatefulWidget {
  const NoteBody({Key? key}) : super(key: key);
  static List<List<String>> tmpText = <List<String>>[];
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
    NoteBody.tmpText.add(List.generate(10, (index) => ''));
    super.initState();
    // Initialize pages with a single page.
    pages = [
      [
        PainterContainer(id: 0),
        TextContainer(id: 0, tmpText: NoteBody.tmpText[0],),
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
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: screenPadding),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter text here',
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              PainterContainer(id: 0).save();
              TextContainer(id: 0, tmpText: NoteBody.tmpText[0],).save();
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
                            TextContainer(id: len, tmpText: NoteBody.tmpText[len],),
                          ]] : [[
                            TextContainer(id: len, tmpText: NoteBody.tmpText[len]),
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

