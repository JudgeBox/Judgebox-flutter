import 'package:flutter/material.dart';

class WebScaffold extends StatefulWidget {
  const WebScaffold({Key? key}) : super(key: key);

  @override
  State<WebScaffold> createState() => _WebScaffoldState();
}

class _WebScaffoldState extends State<WebScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
    );
  }
}