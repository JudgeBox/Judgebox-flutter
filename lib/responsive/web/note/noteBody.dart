import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:judgebox/constants.dart';
import 'package:judgebox/main.dart';
import 'package:judgebox/responsive/web/note/paintBody.dart';
import 'package:judgebox/responsive/web/note/textBody.dart';
import 'package:judgebox/responsive/web/webBody.dart';

import '../../responsiveLayout.dart';
import '../webScaffold.dart';

class NoteBody extends StatefulWidget {
  static List<List<String>> tmpText = <List<String>>[];
  static List<List<PaintData>> tmpPaint = <List<PaintData>>[];
  static List<List<Widget>> pages = [];
  static bool checkUpdate = false;

  final String title;
  final bool New;
  const NoteBody({Key? key, required this.title, required this.New})
      : super(key: key);

  @override
  State<NoteBody> createState() => _NoteBody();
}

class _NoteBody extends State<NoteBody> {
  late TextEditingController title;
  final buttonKey = GlobalKey();
  final textBoxKey = GlobalKey();
  bool _isTop = true, _hasTitle = true;

  void _changeOrder() {
    setState(() {
      _isTop = !_isTop;
    });
  }

  Future<void> saveTitle(String title) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection("title").doc("title").set({
      "title": FieldValue.arrayUnion([title])
    }, SetOptions(merge: true));
  }

  Future<void> loadData(String title) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var docs = await FirebaseFirestore.instance.collection(title).get();
    final double len = docs.size / 2;
    NoteBody.pages = [];
    NoteBody.tmpText = [];
    for (int i = 0; i < len; i++) {
      NoteBody.tmpText.add(List.generate(10, (index) => ''));
      NoteBody.pages += [
        [
          PainterContainer(id: i, title: title),
          TextContainer(id: i, tmpText: NoteBody.tmpText[i], title: title),
        ],
      ];
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    NoteBody.pages = [];
    if (widget.New == true) {
      NoteBody.tmpText.clear();
      NoteBody.tmpText.add(List.generate(10, (index) => ''));
      title = TextEditingController(text: widget.title);
      NoteBody.pages = [
        [
          PainterContainer(id: 0, title: widget.title),
          TextContainer(
              id: 0, tmpText: NoteBody.tmpText[0], title: widget.title),
        ],
      ];
    } else {
      _hasTitle = false;
      title = TextEditingController();
      title.text = widget.title;
      loadData(widget.title);
    }
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
          child: _hasTitle
              ? TextField(
                  controller: title,
                  decoration: InputDecoration(
                    hintText: 'Enter text here',
                  ),
                )
              : Text(title.text),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (title.text == "") {
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
              for (int i = 0; i < NoteBody.pages.length; i++) {
                PainterContainer(
                  id: i,
                  title: title.text,
                ).save();
                TextContainer(
                  id: i,
                  tmpText: NoteBody.tmpText[i],
                  title: title.text,
                ).save();
              }
              NoteBody.pages = [];
              saveTitle(title.text);

              //WebBody().load();
              Navigator.pop(context, true);
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
                        print(NoteBody.tmpText);
                        NoteBody.pages = NoteBody.pages
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
                        int len = NoteBody.pages.length;
                        NoteBody.tmpText.add(List.generate(10, (index) => ''));
                        NoteBody.pages += _isTop
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
              itemCount: NoteBody.pages.length,
              itemBuilder: (context, index) {
                print(NoteBody.pages.length);
                if (NoteBody.pages.length == 0) return Container();
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
                                children: NoteBody.pages[index],
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
