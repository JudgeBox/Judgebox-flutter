import 'package:flutter/material.dart';
import 'package:judgebox/constants.dart';
import 'package:judgebox/responsive/web/webBody.dart';


class WebScaffold extends StatefulWidget {
  const WebScaffold({Key? key}) : super(key: key);

  @override
  State<WebScaffold> createState() => _WebScaffoldState();
}

class _WebScaffoldState extends State<WebScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: webAppBar,
      backgroundColor: judgeBackground,
      body: WebBody(),
    );
  }
}