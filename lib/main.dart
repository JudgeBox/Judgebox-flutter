import 'package:flutter/material.dart';
import 'package:judgebox/responsive/responsive_layout.dart';
import 'package:judgebox/responsive/mobile/mobile_scaffold.dart';
import 'package:judgebox/responsive/tablet_scaffold.dart';
import 'package:judgebox/responsive/web/web_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JudgeBox',
      home: ResponsiveLayout(
        mobileScaffold: const MobileScaffold(),
        tabletScaffold: const TabletScaffold(),
        webScaffold: const WebScaffold(),
      ),
    );
  }
}