import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:judgebox/responsive/responsiveLayout.dart';
import 'package:judgebox/responsive/mobile/mobileScaffold.dart';
import 'package:judgebox/responsive/tabletScaffold.dart';
import 'package:judgebox/responsive/web/webScaffold.dart';

import 'firebase_options.dart';

// import 'package:mongo_dart/mongo_dart.dart';
// import 'dart:io' show Platform;

import 'package:http/http.dart' as http;
import 'dart:convert';

void connect() async {
  print("try http request");

  final response = await http.get(Uri.parse('http://localhost:3000/CF'));
  if (response.statusCode == 200) {
    // handle the response
    final jsonResponse = json.decode(response.body);
    final first = jsonResponse[0];
    print(first);
  } else {
    // handle the error
    print('Request failed with status: ${response.statusCode}.');
  }
}

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  connect();
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
        theme: ThemeData(useMaterial3: true));
  }
}
