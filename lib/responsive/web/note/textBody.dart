import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:judgebox/responsive/web/note/noteBody.dart';

class TextContainer extends StatefulWidget {
  final int id;
  final List<String> tmpText;
  const TextContainer({Key? key, required this.id, required this.tmpText}) : super(key: key);

  @override
  State<TextContainer> createState() => _TextContainerState();
  @override
  Future<void> save() => _TextContainerState()._saveText(id);
}

class _TextContainerState extends State<TextContainer> {
  List<TextEditingController> _controllers = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      _controllers.add(TextEditingController(text: ""));
    }
    _loadText();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> toMap(List<String> list) {
    Map<String, dynamic> result = {};
    for (int i = 0; i < list.length; i++) {
      result['item$i'] = list[i];
    }
    return result;
  }

  Future<void> _saveText(int id) async {
    final List<String> text = NoteBody.tmpText[id];
    await _firestore.collection('NoteText').add({'Text': text});
  }

  Future<void> _loadText() async {
    final snapshot = await _firestore.collection('NoteText').get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      if (data.containsKey('Text')) {
        final List<dynamic> text = data['Text'];
        if (text != null) {
          final List<String> tmpText = List.castFrom<dynamic, String>(text);
          setState(() {
            NoteBody.tmpText[widget.id] = tmpText;
            for (int i = 0; i < 10; i++) {
              _controllers[i] = TextEditingController(text: tmpText[i]);
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
    List<String> tmpText = widget.tmpText;

    int listLength = 10;
    List<FocusNode> _focusNodes = List<FocusNode>.generate(listLength, (int index) => FocusNode());

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
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onSubmitted: (String value) {
              if (index < listLength) {
                _focusNodes[index + 1].requestFocus();
              }
            },
            onChanged: (value) {
              NoteBody.tmpText[id][index] = value;
            },
          ),
        ));

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