import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({Key? key}) : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: judgeBackground,
      appBar: webAppBar,
      body: Row(
        children: [
        ],
      ),
    );
  }
}