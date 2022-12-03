import 'package:flutter/material.dart';
import 'package:judgebox/responsive/responsiveLayout.dart';
import 'package:judgebox/responsive/mobile/mobileScaffold.dart';
import 'package:judgebox/responsive/tabletScaffold.dart';
import 'package:judgebox/responsive/web/webScaffold.dart';

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