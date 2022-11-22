import 'package:flutter/material.dart';

var judgeBackground = Colors.grey[300];

var mobileAppBar = AppBar(
  centerTitle: true,
  title: const Text('JudgeBox'),
  backgroundColor: Colors.black54,
);

var webAppBar = AppBar(
  backgroundColor: Colors.black26,
);

var judgeDrawer = Drawer(
  backgroundColor: Colors.grey[300],
  child: Column(
    children: const [
      DrawerHeader(child: Icon(Icons.photo)),
      ListTile(
        title: Text('owo'),
      )
    ],
  ),
);