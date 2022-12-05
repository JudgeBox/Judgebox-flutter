import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';
import 'package:judgebox/responsive/web/note/noteBody.dart';


class NoteScaffold extends StatefulWidget {
  const NoteScaffold({Key? key}) : super(key: key);

  @override
  State<NoteScaffold> createState() => _NoteScaffoldState();
}

var webAppBar = AppBar(
  backgroundColor: Colors.black26,
);

class _NoteScaffoldState extends State<NoteScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: webAppBar,
      backgroundColor: judgeBackground,
      body: NoteBody(),
    );
  }
}