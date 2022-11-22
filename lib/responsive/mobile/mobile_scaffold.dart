import 'package:flutter/material.dart';
import 'package:judgebox/responsive/mobile/mobileBody.dart';

import '../../constants.dart';
import 'mobileDrawer.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mobileAppBar,
      backgroundColor: judgeBackground,
      body: MobileBody(),
      drawer: CustomDrawer(),
    );
  }


}